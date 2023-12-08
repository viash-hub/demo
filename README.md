
Example:

First of all, build the workflow component and fetch the dependencies:

```sh
❯ viash ns build
temporaryFolder: /tmp/viash_hub_repo16588771316891105298 uri: https://github.com/openpipelines-bio/openpipeline.git
Cloning into '.'...
checkout out: List(git, checkout, tags/0.12.1, --, .) 0
Creating temporary 'target/.build.yaml' file for op as this file seems to be missing.
Exporting parallel_qc (workflows) =nextflow=> /Users/toni/code/projects/viash-hub/demo/target/nextflow/workflows/parallel_qc
All 1 configs built successfully
```

Then, run:

```sh
❯ nextflow run target/nextflow/workflows/parallel_qc/main.nf \
    --input "testData/*" \
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
