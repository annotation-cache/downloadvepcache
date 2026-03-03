process CURL {
    tag "${meta.id}"
    label 'process_low'

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
        ? 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/8c/8c60c36ae45b5244cc9e4eb1353e7bd7380882779bd9ad3673427f2be75237b9/data'
        : 'community.wave.seqera.io/library/curl:8.18.0--78f80c4b644630b0'}"

    input:
    tuple val(meta), val(assembly), val(species), val(cache_version)

    output:
    tuple val(meta), path(prefix), emit: cache
    tuple val("${task.process}"), val('curl'), eval("curl --version | sed -n '1s/curl \\([^ ]*\\).*/\\1/p'"), topic: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix   = task.ext.prefix ?: 'vep_cache'
    filename = "${species}_vep_${cache_version}_${assembly}.tar.gz"
    url      = "https://ftp.ensembl.org/pub/release-${cache_version}/variation/indexed_vep_cache"
    """
    curl -fsSL "${url}/${filename}" -o "${filename}"
    curl -fsSL "${url}/CHECKSUMS" -o CHECKSUMS

    # Verify checksum (BSD sum — the algorithm Ensembl uses in CHECKSUMS)
    EXPECTED=\$(awk '\$NF == "${filename}" {print \$1}' CHECKSUMS)

    if [ -z "\${EXPECTED}" ]; then
        echo "ERROR: ${filename} not found in CHECKSUMS file" >&2
        exit 1
    fi

    ACTUAL=\$(sum "${filename}" | awk '{print \$1}')

    if [ "\${EXPECTED}" != "\${ACTUAL}" ]; then
        echo "ERROR: Checksum mismatch for ${filename}" >&2
        echo "  Expected: \${EXPECTED}" >&2
        echo "  Actual:   \${ACTUAL}" >&2
        exit 1
    fi

    echo "Checksum verified for ${filename}"

    mkdir -p "${prefix}"
    tar xzf "${filename}" -C "${prefix}"
    rm "${filename}" CHECKSUMS
    """

    stub:
    prefix = task.ext.prefix ?: 'vep_cache'
    """
    mkdir "${prefix}"
    """
}
