
# Introduction

TODO

# Test data

We will fetch test data from this repository: <https://github.com/hartwigmedical/testdata>:

```sh
git clone https://github.com/hartwigmedical/testdata testData 
```

# Run directly from ~Github~ ViashHub

```sh
https://github.com/viash-io/viash_hub_demo \
    -main-script target/nextflow/workflows/parallel_qc/main.nf \
    -r main \
    --input "testData/**/*.fastq.gz"  \
    --publish_dir output \
    -with-docker
```

# Run from a local copy

First of all, build the workflow component and fetch the dependencies:

```sh
❯ viash ns build
temporaryFolder: /tmp/viash_hub_repo5484030342718552259 uri: https://github.com/openpipelines-bio/openpipeline.git
Cloning into '.'...
checkout out: List(git, checkout, tags/0.12.1, --, .) 0
Creating temporary 'target/.build.yaml' file for op as this file seems to be missing.
Exporting parallel_qc (workflows) =nextflow=> <...>/demo/target/nextflow/workflows/parallel_qc
Exporting transpose (utils) =nextflow=> <...>/demo/target/nextflow/utils/transpose
All 2 configs built successfully
```

Now, run fastqc on all fastq files that can be found under in the `testData` directory:

```sh
❯ nextflow run target/nextflow/workflows/parallel_qc/main.nf \
    --input "testData/**/*.fastq.gz"  \
    --publish_dir output \
    -with-docker
N E X T F L O W  ~  version 22.10.7
Launching `target/nextflow/workflows/parallel_qc/main.nf` [hungry_allen] DSL2 - revision: ce88dd9a3a
executor >  local (64)
[db/2de3bc] process > parallel_qc:run_wf:fastqc:fastqc_process (TESTY_H7YRLADXX_S1_L002_R1_001.fastq.gz)                      [100%] 32 of 32 ✔
[46/d0870d] process > parallel_qc:publishStatesSimpleWf:publishStatesProc (TESTY_H7YRLADXX_S1_L002_R1_001.fastq.gz)           [100%] 32 of 32 ✔
```


