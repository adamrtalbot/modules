process PICARD_COLLECTINSERTSIZEMETRICS {
    tag "$meta.id"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::picard=2.27.2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/picard:2.27.2--hdfd78af_0' :
        'quay.io/biocontainers/picard:2.27.2--hdfd78af_0' }"

    input:
    tuple val(meta), path(bam)
    path fasta

    output:
    tuple val(meta), path("*.txt"), emit: stats
    tuple val(meta), path("*.pdf"), emit: pdf
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args      = task.ext.args   ?: ''
    def prefix    = task.ext.prefix ?: "${meta.id}"
    def reference = fasta           ? "--REFERENCE_SEQUENCE ${fasta}" : ""

    def avail_mem = 3
    if (!task.memory) {
        log.info '[Picard CollectInserSizeMetrics] Available memory not known - defaulting to 3GB. Specify process memory requirements to change this.'
    } else {
        avail_mem = task.memory.giga
    }
    """
    picard \\
        -Xmx${avail_mem}g \\
        CollectInsertSizeMetrics \\
        $args \\
        $reference \\
        --INPUT $bam \\
        --OUTPUT ${prefix}.insertsize.txt \\
        --Histogram_FILE ${prefix}.insertsize.pdf


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        picard: \$(echo \$(picard CollectHsMetrics --version 2>&1) | grep -o 'Version:.*' | cut -f2- -d:)
    END_VERSIONS
    """

    stub:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    touch ${prefix}.insertsize.txt
    touch ${prefix}.insertsize.pdf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        picard: \$(echo \$(picard CollectHsMetrics --version 2>&1) | grep -o 'Version:.*' | cut -f2- -d:)
    END_VERSIONS
    """
}
