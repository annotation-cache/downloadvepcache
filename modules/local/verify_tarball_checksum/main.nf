process VERIFY_TARBALL_CHECKSUM {
    tag "${meta.id}"
    label 'process_medium'

    conda 'conda-forge::curl=8.11.1 conda-forge::coreutils=9.5'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/c2/c2517dd7059e17723487dc7edc645aee8829392e28bcca06cb82bc202eaf11c8/data' :
        'community.wave.seqera.io/library/curl_coreutils:c6e9f037399e0796' }"

    input:
    tuple val(meta), val(assembly), val(species), val(cache_version)

    output:
    tuple val(meta), path(prefix), emit: cache
    path "versions.yml",           emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    prefix = task.ext.prefix ?: 'vep_cache'
    // Tarball naming convention: {species}_vep_{version}_{assembly}.tar.gz
    def tarball = "${species}_vep_${cache_version}_${assembly}.tar.gz"
    // FTP base URL — release ≥115 uses indexed_vep_cache/, older uses vep/
    def ftp_base = "https://ftp.ensembl.org/pub/release-${cache_version}/variation"
    """
    # Try indexed_vep_cache first (pre-indexed, no conversion needed), fall back to vep/
    CHECKSUMS_URL=""
    TARBALL_URL=""
    for subdir in indexed_vep_cache vep; do
        HTTP_CODE=\$(curl -sS -o /dev/null -w "%{http_code}" "${ftp_base}/\${subdir}/CHECKSUMS")
        if [ "\${HTTP_CODE}" = "200" ]; then
            CHECKSUMS_URL="${ftp_base}/\${subdir}/CHECKSUMS"
            TARBALL_URL="${ftp_base}/\${subdir}/${tarball}"
            break
        fi
    done

    if [ -z "\${CHECKSUMS_URL}" ]; then
        echo "ERROR: Could not find CHECKSUMS file at Ensembl FTP for release ${cache_version}" >&2
        exit 1
    fi

    # Download CHECKSUMS file
    curl -fsSL "\${CHECKSUMS_URL}" -o CHECKSUMS

    # Extract expected checksum for our tarball
    # Format varies: "checksum blockcount filename" or "checksum blockcount path filename"
    EXPECTED=\$(grep "${tarball}" CHECKSUMS | awk '{print \$1}')
    if [ -z "\${EXPECTED}" ]; then
        echo "ERROR: Tarball ${tarball} not found in CHECKSUMS file" >&2
        exit 1
    fi

    # Download the tarball
    echo "Downloading \${TARBALL_URL}..."
    curl -fsSL "\${TARBALL_URL}" -o "${tarball}"

    # Verify checksum using BSD sum (same as Ensembl uses)
    ACTUAL=\$(sum "${tarball}" | awk '{print \$1}')
    if [ "\${ACTUAL}" != "\${EXPECTED}" ]; then
        echo "ERROR: Checksum mismatch for ${tarball}" >&2
        echo "  Expected: \${EXPECTED}" >&2
        echo "  Actual:   \${ACTUAL}" >&2
        exit 1
    fi
    echo "Checksum verified: \${ACTUAL} == \${EXPECTED}"

    # Extract
    mkdir -p "${prefix}"
    tar -xzf "${tarball}" -C "${prefix}"
    rm "${tarball}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        curl: \$(curl --version | head -1 | awk '{print \$2}')
    END_VERSIONS
    """

    stub:
    prefix = task.ext.prefix ?: 'vep_cache'
    """
    mkdir -p "${prefix}/${species}/${cache_version}_${assembly}"

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        curl: \$(curl --version | head -1 | awk '{print \$2}')
    END_VERSIONS
    """
}
