def VERSION = '1.6.17'

process VCF2MAF {
    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? "bioconda::vcf2maf=1.6.21" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/vcf2maf:1.6.12--0':
        'quay.io/biocontainers/vcf2maf:1.6.21--hdfd78af_0' }"

    input:
    tuple val(meta), path(vcf) // Use an uncompressed VCF file!
    path fasta                 // required

    output:
    tuple val(meta), path("*.maf"), emit: maf
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args          = task.ext.args   ?: ''
    def prefix        = task.ext.prefix ?: "${meta.id}"
    """
    vcf2maf.pl \\
        $args \\
        --ref-fasta $fasta \\
        --inhibit-vep \\
        --input-vcf $vcf \\
        --output-maf ${prefix}.maf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        vcf2maf: $VERSION
    END_VERSIONS
    """
}
