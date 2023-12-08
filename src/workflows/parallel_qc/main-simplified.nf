workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch
      | flatMap{ id, state ->
          state.input
            .collect{ f ->
              [ 
                file(f).name.minus(".fastq.gz"),
                [ input: file(f) ]
              ]
            }
        }
      | fastqc.run(
          auto: [ publish: true ],
          fromState: { id, state ->
            [
              mode: "files",
              input: state.input,
            ]
          },
          toState: { id, result, state ->
            [ output: result.output ]
          }
        )
      | map{ id, state -> [ "run", state ] }

  emit:
    output_ch
}
