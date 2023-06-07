process BWA_REALIGN {
    tag "$meta.id"
    label 'process_medium'

    conda "bioconda::bwa=0.7.17 bioconda::samtools=1.16.1"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3ff0bf0c5c81a5135ab4-0' :
        'biocontainers/mulled-v2-fe8faa35dbf6dc65a0f7f5d4ea12e31a79f73e40:219b6c272b25e7e642ae3ff0bf0c5c81a5135ab4-0' }"

    input:
    tuple val(meta) , path(bam),  path(bai)
    tuple val(meta2), path(index)

    output:
    tuple val(meta), path("*.bam")    , emit: bam
    tuple val(meta), path("*.bam.bai"), emit: index
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    INDEX=`find -L ./ -name "*.amb" | sed 's/\\.amb\$//'`

    samtools collate -Oun128 ${bam} \\
        | samtools fastq -Ot - \\
        | bwa mem -p -t ${task.cpus} -CH <(samtools view -H ${bam} | grep ^@RG) \$INDEX - \\
        | samtools sort -@ ${task.cpus} -m ${task.memory.toGiga()} -o ${prefix}.bam - \\
    samtools index -@ ${task.cpus} ${prefix}.bam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        bwa: \$(echo \$(bwa 2>&1) | sed 's/^.*Version: //; s/Contact:.*\$//')
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}

