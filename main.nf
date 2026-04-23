
nextflow.enable.dsl=2

include { PREPARE }      from './modules/local/prepare'
include { CNMF }         from './modules/local/cnmf'
include { JACCARD }      from './modules/local/jaccard'
include { GEP_ANALYSIS } from './modules/local/gep_analysis'

workflow {

    if( !params.input_h5ad ) {
        error "Please provide --input_h5ad"
    }

    if( params.k_min > params.k_max ) {
        error "Please provide k_min <= k_max"
    }

    if( params.k_step < 1 ) {
        error "Please provide k_step >= 1"
    }

    counts_ch   = Channel.fromPath(params.input_h5ad)
    k_values    = (params.k_min..params.k_max).step(params.k_step).toList()
    k_ch        = Channel.of(*k_values)

    prepare_out = PREPARE(counts_ch)

    cnmf_input  = prepare_out.combine(k_ch)
    cnmf_out    = CNMF(cnmf_input)

    jaccard_out = JACCARD(cnmf_out)

    GEP_ANALYSIS(jaccard_out.collect())
}