#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { PICARD_COLLECTINSERTSIZEMETRICS } from '../../../../modules/picard/collectinsertsizemetrics/main.nf'

workflow test_picard_collectinsertsizemetrics {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    fasta = file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)

    PICARD_COLLECTINSERTSIZEMETRICS ( input, fasta )
}

workflow test_picard_collectinsertsizemetrics_no_fasta {

    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    PICARD_COLLECTINSERTSIZEMETRICS ( input, [] )
}
