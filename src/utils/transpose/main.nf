workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      | flatMap{ id, state ->
          state.input
            .collect{ f ->
              [ 
                file(f).name,
                [
                  output: file(f),
                  _meta: [ join_id: "run" ]
                ]
              ]
            }
        }

  emit:
    output_ch
}
