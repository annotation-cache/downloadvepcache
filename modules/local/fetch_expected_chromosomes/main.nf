process FETCH_EXPECTED_CHROMOSOMES {
    tag "${species}/${assembly}"
    label 'process_single'

    conda 'conda-forge::curl=8.11.1 conda-forge::jq=1.7.1'
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/c2/c20c04954f1159f9a9faa27eed38e60a9498e54c12b838fc46032e895a0ba9c8/data' :
        'community.wave.seqera.io/library/curl_jq:6147f96d8fd831b2' }"

    input:
    tuple val(meta), val(assembly), val(species), val(cache_version)

    output:
    tuple val(meta), path("expected_chromosomes.txt"), emit: chromosomes
    path "versions.yml",                               emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    curl -sS "https://rest.ensembl.org/info/assembly/${species}?content-type=application/json" \\
        | jq -r '.karyotype[]' \\
        | sort > expected_chromosomes.txt

    # Fail if we got no chromosomes
    if [ ! -s expected_chromosomes.txt ]; then
        echo "ERROR: No karyotype data returned from Ensembl REST API for ${species}" >&2
        exit 1
    fi

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        curl: \$(curl --version | head -1 | awk '{print \$2}')
        jq: \$(jq --version | sed 's/jq-//')
    END_VERSIONS
    """

    stub:
    """
    echo "stub_chr" > expected_chromosomes.txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        curl: \$(curl --version | head -1 | awk '{print \$2}')
        jq: \$(jq --version | sed 's/jq-//')
    END_VERSIONS
    """
}
