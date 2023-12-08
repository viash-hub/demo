workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      // Expand the input wildcard, i.e. convert the input channel
      //  `[ _, [ input: [ <fastqfiles> ] ] ]`
      // into seperate events of the format:
      //  `[ <filename>, [ input: <fastqfile> ] ]`
      // 
      // This involves some Nextflow and Groovy magic.
      | flatMap{ id, state ->
          state.input
            .collect{ f ->
              [ 
                file(f).name.minus(".fastq.gz"),  // remove the trail
                [ input: file(f) ]                // file expands the glob
              ]
            }
        }

      // Run the fastqc component on every fastq file in the channel
      | fastqc.run(
          // Publish the results
          auto: [ publish: true ],
          // Pass the appropriate arguments to the fastqc module
          fromState: { id, state ->
            [
              mode: "files",         // required argument for fastqc
              input: state.input,    // each individual fastq file
            ]
          },
          // Define how the output of the fastqc module should be handled
          toState: { id, result, state ->
            [ output: result.output ]
          }  // add the output to state.output
        )

      // Make sure the output and input channel ID's match
      // and the output arguments are passed.
      // Note: There are other ways to handle this with Viash
      | map{ id, state -> [ "run", state ] }

  emit:
    output_ch
}
