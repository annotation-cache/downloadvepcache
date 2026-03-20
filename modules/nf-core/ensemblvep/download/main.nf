process ENSEMBLVEP_DOWNLOAD {
    tag "${meta.id}"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container
        ? 'https://community-cr-prod.seqera.io/docker/registry/v2/blobs/sha256/4b/4b5a8c173dc9beaa93effec76b99687fc926b1bd7be47df5d6ce19d7d6b4d6b7/data'
        : 'community.wave.seqera.io/library/ensembl-vep:115.2--90ec797ecb088e9a'}"

    input:
    tuple val(meta), val(assembly), val(species), val(cache_version)

    output:
    tuple val(meta), path(prefix), emit: cache
    tuple val("${task.process}"), val('ensemblvep'), eval("vep --help | sed -n '/ensembl-vep/s/.*: //p'"), topic: versions, emit: versions_ensemblvep

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: 'vep_cache'
    def filename = "${species}_vep_${cache_version}_${assembly}.tar.gz"
    def checksums_url = "https://ftp.ensembl.org/pub/release-${cache_version}/variation/indexed_vep_cache/CHECKSUMS"
    def verify = params.verify_checksums != null ? params.verify_checksums : true
    """
    # Pre-flight: verify CHECKSUMS file exists and lists our expected cache file
    if [ "${verify}" = "true" ]; then
        perl -MHTTP::Tiny -e '
            my \$r = HTTP::Tiny->new(timeout => 30)->get("${checksums_url}");
            \$r->{success} or die "Failed to fetch CHECKSUMS (HTTP \$r->{status})\\n";
            \$r->{content} =~ /\\Q${filename}\\E/ or die "${filename} not found in CHECKSUMS\\n";
            print "Pre-flight OK: CHECKSUMS lists ${filename}\\n";
        '
    else
        echo "Skipping CHECKSUMS verification (verify_checksums = false)"
    fi

    vep_install \\
        --CACHEDIR ${prefix} \\
        --SPECIES ${species} \\
        --ASSEMBLY ${assembly} \\
        --CACHE_VERSION ${cache_version} \\
        ${args}
    """

    stub:
    prefix = task.ext.prefix ?: 'vep_cache'
    """
    mkdir ${prefix}
    """
}
