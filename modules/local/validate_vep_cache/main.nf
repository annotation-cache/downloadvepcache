process VALIDATE_VEP_CACHE {
    tag "${meta.id}"
    label 'process_single'

    conda 'conda-forge::coreutils=9.5'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/93/93350362d283b4e15f25b1c6d7f56c41f4394072afbd7dfc273eb453feaa7e74/data' :
        'community.wave.seqera.io/library/coreutils:9.5--5e21c082d2c8bc07' }"

    input:
    tuple val(meta), path(cache_dir), val(assembly), val(species), val(cache_version)
    tuple val(_), path(expected_chromosomes)

    output:
    tuple val(meta), path(cache_dir),        emit: cache
    tuple val(meta), path("manifest.md5"),   emit: manifest
    path "validation_report.txt",            emit: report
    path "versions.yml",                     emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    CACHE_SUBDIR="${cache_dir}/${species}/${cache_version}_${assembly}"

    if [ ! -d "\${CACHE_SUBDIR}" ]; then
        echo "ERROR: Expected cache directory not found: \${CACHE_SUBDIR}" >&2
        exit 1
    fi

    MISSING=""
    FOUND=0
    TOTAL=0
    while IFS= read -r chr; do
        TOTAL=\$((TOTAL + 1))
        CHR_DIR="\${CACHE_SUBDIR}/\${chr}"
        if [ ! -d "\${CHR_DIR}" ]; then
            MISSING="\${MISSING}\${chr}\\n"
        elif [ -z "\$(ls -A "\${CHR_DIR}")" ]; then
            MISSING="\${MISSING}\${chr} (empty)\\n"
        else
            FOUND=\$((FOUND + 1))
        fi
    done < ${expected_chromosomes}

    find -L "${cache_dir}" -type f -exec md5sum {} + | sort > manifest.md5

    printf "VEP Cache Validation Report\\n" > validation_report.txt
    printf "===========================\\n" >> validation_report.txt
    printf "Species:       ${species}\\n" >> validation_report.txt
    printf "Assembly:      ${assembly}\\n" >> validation_report.txt
    printf "Cache version: ${cache_version}\\n" >> validation_report.txt
    printf "Cache dir:     ${cache_dir}\\n\\n" >> validation_report.txt
    printf "Chromosomes expected: \${TOTAL}\\n" >> validation_report.txt
    printf "Chromosomes found:    \${FOUND}\\n" >> validation_report.txt

    if [ -n "\${MISSING}" ]; then
        printf "\\nMISSING CHROMOSOMES:\\n" >> validation_report.txt
        printf "\${MISSING}" >> validation_report.txt
        printf "\\nVALIDATION FAILED\\n" >> validation_report.txt
        echo "ERROR: Missing chromosome directories in VEP cache:" >&2
        printf "\${MISSING}" >&2
        exit 1
    else
        printf "\\nVALIDATION PASSED - All chromosomes present and non-empty\\n" >> validation_report.txt
    fi

    cat validation_report.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        coreutils: \$(md5sum --version | head -1 | awk '{print \$NF}')
    END_VERSIONS
    """

    stub:
    """
    echo "stub validation" > validation_report.txt
    echo "d41d8cd98f00b204e9800998ecf8427e  stub" > manifest.md5

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        coreutils: \$(md5sum --version | head -1 | awk '{print \$NF}')
    END_VERSIONS
    """
}
