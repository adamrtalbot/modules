#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { VCF2MAF } from '../../../modules/vcf2maf/main.nf'

workflow test_vcf2maf {

    input_vcf = [
        [ id:'test' ],
        file(params.test_data['homo_sapiens']['illumina']['test_genome_vcf'], checkIfExists: true)
    ]
    fasta = [ file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]

    VCF2MAF ( input_vcf, fasta )
}
