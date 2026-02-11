/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { FETCH_EXPECTED_CHROMOSOMES } from '../modules/local/fetch_expected_chromosomes'
include { VERIFY_TARBALL_CHECKSUM    } from '../modules/local/verify_tarball_checksum'
include { VALIDATE_VEP_CACHE         } from '../modules/local/validate_vep_cache'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow DOWNLOADVEPCACHE {
    take:
    ensemblvep_info // channel: [ meta, assembly, species, cache_version ]

    main:
    ch_versions = Channel.empty()

    //
    // Step 1: Fetch expected chromosomes from Ensembl REST API
    //
    FETCH_EXPECTED_CHROMOSOMES(ensemblvep_info)
    ch_versions = ch_versions.mix(FETCH_EXPECTED_CHROMOSOMES.out.versions)

    //
    // Step 2: Download tarball, verify FTP checksum, extract
    //
    VERIFY_TARBALL_CHECKSUM(ensemblvep_info)
    ch_versions = ch_versions.mix(VERIFY_TARBALL_CHECKSUM.out.versions)

    //
    // Step 3: Validate extracted cache against expected chromosomes + generate manifest
    //
    // Combine cache output with assembly/species/version for validation
    ch_validate_input = VERIFY_TARBALL_CHECKSUM.out.cache
        .join(ensemblvep_info.map { meta, assembly, species, cache_version ->
            [meta, assembly, species, cache_version]
        })

    VALIDATE_VEP_CACHE(
        ch_validate_input,
        FETCH_EXPECTED_CHROMOSOMES.out.chromosomes
    )
    ch_versions = ch_versions.mix(VALIDATE_VEP_CACHE.out.versions)

    emit:
    ensemblvep_cache = VALIDATE_VEP_CACHE.out.cache.collect()    // channel: [ meta, cache ]
    manifest         = VALIDATE_VEP_CACHE.out.manifest.collect() // channel: [ meta, manifest.md5 ]
    report           = VALIDATE_VEP_CACHE.out.report.collect()   // channel: [ validation_report.txt ]
    versions         = ch_versions                               // channel: [ versions.yml ]
}
