
Example:

```sh
❯ nextflow run target/nextflow/workflows/parallel_qc/main.nf \
    --input testData/\* \
    --publish_dir output \
    -with-docker

N E X T F L O W  ~  version 22.10.7
Launching `target/nextflow/workflows/parallel_qc/main.nf` [marvelous_davinci] DSL2 - revision: 5de718899e
executor >  local (2)
[bd/31cdcf] process > parallel_qc:run_wf:fastqc:fastqc_process (Exp_AGGATAGC_S4_L001_R2_001) [100%] 2 of 2 ✔
[-        ] process > parallel_qc:publishStatesSimpleWf:publishStatesProc                    -
Completed at: 08-Dec-2023 16:54:40
Duration    : 1m 15s
CPU hours   : (a few seconds)
Succeeded   : 2
```
