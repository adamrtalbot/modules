def VERSION = '1.6.21'

process VCF2MAF {
    /*
    This runs vcf2maf on an uncompressed VCF file and converts it to MAF format.

    vcf2maf uses VEP to annotate and validate variants, however in order to keep isolation of processes this assumes you have ran VEP on your VCF beforehand.

    This means that the process is much simpler and has fewer dependencies. If you do not run VEP beforehand you will find a valid but mostly empty MAF file.

    If VEP is installed you can run:
    vcf2maf.pl --ref-fasta reference.fasta --input-vcf sample.vcf --output-maf sample.maf --vep-data .vep/ --vep-path $(dirname $(type -p vep))
    */

    tag "$meta.id"
    label 'process_low'

    conda (params.enable_conda ? "bioconda::vcf2maf=1.6.21" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/vcf2maf:1.6.21--hdfd78af_0':
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
        --inhibit-vep \\
        --ref-fasta $fasta \\
        --input-vcf $vcf \\
        --output-maf ${prefix}.maf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        vcf2maf: $VERSION
    END_VERSIONS
    """
}

