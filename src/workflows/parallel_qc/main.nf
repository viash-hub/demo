workflow run_wf {
  take:
    input_ch

  main:
    fastqc_output = input_ch

      // Turn the Channel event with list of files
      // into a multiple Channel events with one file.
      | expand.run(
          fromState: { id, state -> state },
          toState: {id, result, state -> result }
      )

      // Run the fastqc component on every fastq file in the channel
      | fastqc.run(
          // Pass the appropriate arguments to the fastqc module
          fromState: { id, state ->
            [
              mode: "files",             // required argument for fastqc
              input: state.output,       // each individual fastq file
            ]
          },
          toState: { id, result, state -> result }
        )

    output_ch = fastqc_output 
      // Aggregate all fastqc reports in one directory,
      // but first run our Nextflow toList wrapper
      | vsh_toList.run (
          fromState: { id, state -> [ id: "run", input: state.output ] },
          toState: { id, result, state -> result }
        )
      | assemble.run(
          fromState: { id, state -> [ input: state.output ] },
          toState: { id, result, state -> result }
        )

      // Run multiqc
      | multiqc.run(
          // Publish the results
          auto: [ publish: true ],
          fromState: { id, state ->
            [
              input: state.output,
              output: "report"          // Output directory name
            ]
          },
          toState: { id, result, state -> [ output: result.output ] }
        )

  emit:
    output_ch
}
