workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      // Turn the Channel event with list of files
      // into a multiple Channel events with one file.
      | transpose.run(
          fromState: [ "input": "input" ],
          toState: [ "transpose_output": "output" ]
      )

      // Run the fastqc component on every fastq file in the channel
      | fastqc.run(
          // Pass the appropriate arguments to the fastqc module
          fromState: { id, state ->
            [
              mode: "files",            // required argument for fastqc
              input: state.transpose_output,       // each individual fastq file
            ]
          },
          // Define how the output of the fastqc module should be handled
          toState: [ "fastqc_output": "output" ]   // add the output to state.output
        )

      // Aggregate all fastqc reports in one directory 
      | toSortedList
      | map{ lst -> 
          [
            "run",
            [ list_fastqc_reports: lst.collect{ id, state -> state.fastqc_output }.join(";") ]
          ]
        }
      | aggregate.run(
          fromState: [ "input": "list_fastqc_reports" ],
          toState: [ "aggregated_fastqc_reports": "output" ]
        )

      // Run multiqc
      | multiqc.run(
          // Publish the results
          auto: [ publish: true ],
          fromState: { id, state ->
            [
              input: state.aggregated_fastqc_reports,
              output: "report"
            ]
          },
          toState: [ "output": "output" ]
        )

  emit:
    output_ch
      | map{ id, state -> [ id, [ output: state.output ] ] }
}
