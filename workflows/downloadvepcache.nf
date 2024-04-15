/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { ENSEMBLVEP_DOWNLOAD    } from '../modules/nf-core/ensemblvep/download/main'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow DOWNLOADVEPCACHE {
    take:
    ensemblvep_info

    main:
    ENSEMBLVEP_DOWNLOAD(ensemblvep_info)

    emit:
    ensemblvep_cache = ENSEMBLVEP_DOWNLOAD.out.cache.collect()  // channel: [ meta, cache ]
    versions         = ENSEMBLVEP_DOWNLOAD.out.versions         // channel: [ versions.yml ]
}
