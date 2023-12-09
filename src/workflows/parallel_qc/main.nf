workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      // Turn the Channel event with list of files
      // into a multiple Channel events with one file.
      | transpose.run(
          fromState: [ "input": "input" ],
          toState: [ "input": "output" ]
      )

      // Run the fastqc component on every fastq file in the channel
      | fastqc.run(
          // Publish the results
          auto: [ publish: true ],
          // Pass the appropriate arguments to the fastqc module
          fromState: { id, state ->
            [
              mode: "files",            // required argument for fastqc
              input: state.input,       // each individual fastq file
            ]
          },
          // Define how the output of the fastqc module should be handled
          toState: { id, result, state ->
            [ output: result.output ]   // add the output to state.output
          }  
        )

  emit:
    output_ch
      // Make sure Viash knows how to match up input and output channels
      | map{ id, state -> [ id, state + [ _meta: [ join_id: "run" ] ] ] }
}
