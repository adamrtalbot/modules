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
    val tumor_id
    val normal_id
    val vcf_tumor_id
    val vcf_normal_id
    val species
    val ncbi_build
    val cache_version


    output:
    tuple val(meta), path("*.maf"), emit: maf
    path "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args          = task.ext.args   ?: ''
    def prefix        = task.ext.prefix ?: "${meta.id}"
    def tumor_id_cmd  = tumor_id        ? "--tumor-id ${tumor_id}"           : ""
    def normal_id_cmd = normal_id       ? "--normal-id ${normal_id}"         : ""
    def tumor_vcf_id  = vcf_tumor_id    ? "--vcf-tumor-id ${vcf_tumor_id}"   : ""
    def normal_vcf_id = vcf_normal_id   ? "--vcf-normal-id ${vcf_normal_id}" : ""
    def species_cmd   = species         ? "--species ${species}"             : ""
    def build_cmd     = ncbi_build      ? "--ncbi-build ${ncbi_build}"       : ""
    def cache_version = cache_version   ? "--cache-version ${cache_version}" : ""
    """
    vcf2maf.pl \\
        $args \\
        --ref-fasta $fasta \\
        --inhibit-vep \\
        ${tumor_id_cmd} \\
        ${normal_id_cmd} \\
        ${tumor_vcf_id} \\
        ${normal_vcf_id} \\
        ${species_cmd} \\
        ${build_cmd} \\
        --input-vcf $vcf \\
        --output-maf ${prefix}.maf

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        vcf2maf: $VERSION
    END_VERSIONS
    """
}
