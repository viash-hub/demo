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
                [ input: file(f),
                  _meta: [ id: id ]
                ]
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
        toState: { id, out, state ->
            [
              output: out.output,
              _meta: state._meta
            ]
          }
      )

  emit:
    output_ch
      | map{ }
}
