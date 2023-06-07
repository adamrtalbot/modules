#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { BWA_REALIGN } from '../../../../../modules/nf-core/bwa/realign/main.nf'

workflow test_bwa_realign {

    input = [ [ id:'test', single_end:false ], // meta map
                file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
            ]

    BWA_REALIGN ( input )
}
