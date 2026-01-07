#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    annotation-cache/downloadvepcache
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/annotation-cache/downloadvepcache
----------------------------------------------------------------------------------------
*/

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { ENSEMBLVEP_DOWNLOAD     } from './modules/nf-core/ensemblvep/download'
include { PIPELINE_INITIALISATION } from './subworkflows/local/utils_nfcore_downloadvepcache_pipeline'
include { PIPELINE_COMPLETION     } from './subworkflows/local/utils_nfcore_downloadvepcache_pipeline'
include { getGenomeAttribute      } from 'plugin/nf-core-utils'
include { softwareVersionsToYAML  } from 'plugin/nf-core-utils'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

params.vep_cache_version = getGenomeAttribute('vep_cache_version')
params.vep_genome        = getGenomeAttribute('vep_genome')
params.vep_species       = getGenomeAttribute('vep_species')

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {

    main:
    // SUBWORKFLOW: Run initialisation tasks
    PIPELINE_INITIALISATION(
        params.version,
        params.validate_params,
        args,
        params.outdir,
        params.genome,
        params.help,
        params.help_full,
        params.show_hidden,
    )

    // WORKFLOW: Run main workflow
    ANNOTATIONCACHE_DOWNLOADVEPCACHE(
        params.vep_cache_version,
        params.vep_genome,
        params.vep_species,
    )

    softwareVersionsToYAML(
        softwareVersions: ANNOTATIONCACHE_DOWNLOADVEPCACHE.out.versions.mix(channel.topic("versions")),
        nextflowVersion: workflow.nextflow.version,
    ).collectFile(
        storeDir: "${params.outdir}/pipeline_info",
        name: 'downloadvepcache_software_versions.yml',
        sort: true,
        newLine: true,
    )

    // SUBWORKFLOW: Run completion tasks
    PIPELINE_COMPLETION(
        params.email,
        params.email_on_fail,
        params.plaintext_email,
        params.outdir,
        params.monochrome_logs,
        params.hook_url,
    )

    publish:
    cache = ANNOTATIONCACHE_DOWNLOADVEPCACHE.out.cache.map { meta, file ->
        [meta + [path: meta.id], file]
    }
}

output {
    cache {
        path { meta, path -> path >> meta.path }
    }
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: DOWNLOAD CACHE FOR VEP DEPENDING ON INPUT
//
workflow ANNOTATIONCACHE_DOWNLOADVEPCACHE {
    take:
    vep_cache_version
    vep_genome
    vep_species

    main:
    ENSEMBLVEP_DOWNLOAD(
        channel.of(
            [
                [id: "${vep_cache_version}_${vep_genome}"],
                vep_genome,
                vep_species,
                vep_cache_version,
            ]
        )
    )

    emit:
    cache    = ENSEMBLVEP_DOWNLOAD.out.cache.collect() // channel: [ meta, cache ]
    versions = ENSEMBLVEP_DOWNLOAD.out.versions // channel: [ versions.yml ]
}
