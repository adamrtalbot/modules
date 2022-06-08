#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { VCF2MAF } from '../../../modules/vcf2maf/main.nf'

workflow test_vcf2maf {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]

    VCF2MAF ( input_vcf, fasta, [], [], [], [], [], [], [] )
}

workflow test_vcf2maf_tumor_id {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta    = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]
    tumor_id = "test"

    VCF2MAF ( input_vcf, fasta, tumor_id, [], [], [], [], [], [] )
}

workflow test_vcf2maf_normal_id {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta    = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]
    normal_id = "test"

    VCF2MAF ( input_vcf, fasta, [], normal_id, [], [], [], [], [] )
}

workflow test_vcf2maf_species {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta    = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]
    species = "homo_sapien"

    VCF2MAF ( input_vcf, fasta, [], [], [], [], species, [], [] )
}

workflow test_vcf2maf_build {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta    = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]
    build = "GRCh38"

    VCF2MAF ( input_vcf, fasta, [], [], [], [], [], build, [] )
}

workflow test_vcf2maf_all {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta    = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]
    tumor_id      = "test"
    normal_id     = "test"
    species       = "homo_sapien"
    build         = "GRCh38"
    cache_version = "105"

    VCF2MAF ( input_vcf, fasta, tumor_id, normal_id, [], [], species, build, cache_version )
}
