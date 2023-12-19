workflow run_wf {
  take:
    input_ch

  main:
    output_ch = input_ch

      // Turn the Channel event with list of files
      // into a multiple Channel events with one file.
      | transpose

      | take(2)

      // Run the fastqc component on every fastq file in the channel
      | fastqc.run(
          args: [ mode: "files" ]
        )

      // Aggregate all fastqc reports in one directory 
      | toSortedList
      | map{ lst -> 
          [
            "run",
            [ input: lst.collect{ id, state -> state }.join(";") ]
          ]
        }

      | aggregate

      // Run multiqc
      | multiqc.run(
          auto: [
            publish: true
          ],
          args: [ output: "report" ]
        )

      | map{ id, state -> [ id, [ output: state ] ] }

      | niceView()

  emit:
    output_ch
      
}
