# annotation-cache/downloadvepcache

[![GitHub Actions CI Status](https://github.com/annotation-cache/downloadvepcache/actions/workflows/ci.yml/badge.svg)](https://github.com/annotation-cache/downloadvepcache/actions/workflows/ci.yml)
[![GitHub Actions Linting Status](https://github.com/annotation-cache/downloadvepcache/actions/workflows/linting.yml/badge.svg)](https://github.com/annotation-cache/downloadvepcache/actions/workflows/linting.yml)
[![Cite with Zenodo](http://img.shields.io/badge/DOI-10.5281/zenodo.8392946-1073c8?labelColor=000000)](https://doi.org/10.5281/zenodo.8392946)
[![nf-test](https://img.shields.io/badge/unit_tests-nf--test-337ab7.svg)](https://www.nf-test.com)

[![Nextflow](https://img.shields.io/badge/nextflow%20DSL2-%E2%89%A524.04.2-23aa62.svg)](https://www.nextflow.io/)
[![run with conda](http://img.shields.io/badge/run%20with-conda-3EB049?labelColor=000000&logo=anaconda)](https://docs.conda.io/en/latest/)
[![run with docker](https://img.shields.io/badge/run%20with-docker-0db7ed?labelColor=000000&logo=docker)](https://www.docker.com/)
[![run with singularity](https://img.shields.io/badge/run%20with-singularity-1d355c.svg?labelColor=000000)](https://sylabs.io/docs/)
[![Launch on Seqera Platform](https://img.shields.io/badge/Launch%20%F0%9F%9A%80-Seqera%20Platform-%234256e7)](https://cloud.seqera.io/launch?pipeline=https://github.com/annotation-cache/downloadvepcache)

## Introduction

**annotation-cache/downloadvepcache** is a bioinformatics pipeline to download VEP cache.

## Usage

> [!NOTE]
> If you are new to Nextflow and nf-core, please refer to [this page](https://nf-co.re/docs/usage/installation) on how to set-up Nextflow. Make sure to [test your setup](https://nf-co.re/docs/usage/introduction#how-to-run-a-pipeline) with `-profile test` before running the workflow on actual data.

First, choose the genome you want to download the VEP cache for. You can find the list of the current available genomes in the shared [genomes.config](https://github.com/annotation-cache/configs/blob/main/genomes.config) file.

Alternatively, you can use the following params to specify the genome, species and build version:

```yml
vep_cache_version: "111"
vep_genome: "GRCh38"
vep_species: "homo_sapiens"
```

Now, you can run the pipeline using:

```bash
nextflow run annotation-cache/downloadvepcache \
   -profile <docker/singularity/.../institute> \
   --genome GRCh38 \
   --outdir <OUTDIR>
```

> [!WARNING]
> Please provide pipeline parameters via the CLI or Nextflow `-params-file` option. Custom config files including those provided by the `-c` Nextflow option can be used to provide any configuration _**except for parameters**_; see [docs](https://nf-co.re/docs/usage/getting_started/configuration#custom-configuration-files).

## Credits

annotation-cache/downloadvepcache was originally written by Maxime U Garcia.

We thank the following people for their extensive assistance in the development of this pipeline:

- @adamrtalbot
- @FriederikeHanssen

## Contributions and Support

If you would like to contribute to this pipeline, please see the [contributing guidelines](.github/CONTRIBUTING.md).

## Citations

If you use annotation-cache/downloadvepcache for your analysis, please cite it using the following doi: [10.5281/zenodo.8392946](https://doi.org/10.5281/zenodo.8392946)

An extensive list of references for the tools used by the pipeline can be found in the [`CITATIONS.md`](CITATIONS.md) file.

This pipeline uses code and infrastructure developed and maintained by the [nf-core](https://nf-co.re) community, reused here under the [MIT license](https://github.com/nf-core/tools/blob/main/LICENSE).

> **The nf-core framework for community-curated bioinformatics pipelines.**
>
> Philip Ewels, Alexander Peltzer, Sven Fillinger, Harshil Patel, Johannes Alneberg, Andreas Wilm, Maxime Ulysse Garcia, Paolo Di Tommaso & Sven Nahnsen.
>
> _Nat Biotechnol._ 2020 Feb 13. doi: [10.1038/s41587-020-0439-x](https://dx.doi.org/10.1038/s41587-020-0439-x).
