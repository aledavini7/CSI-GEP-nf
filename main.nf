
nextflow.enable.dsl=2

include { PREPARE }      from './modules/local/prepare'
include { CNMF }         from './modules/local/cnmf'
include { JACCARD }      from './modules/local/jaccard'
include { GEP_ANALYSIS } from './modules/local/gep_analysis'

workflow {

    if( !params.input_h5ad ) {
        error "Please provide --input_h5ad"
    }

    counts_ch   = Channel.fromPath(params.input_h5ad)
    k_values    = params.k_list.tokenize(',').collect { it.trim() as Integer }
    k_ch        = Channel.of(*k_values)

    prepare_out = PREPARE(counts_ch)

    cnmf_input  = prepare_out.combine(k_ch)
    cnmf_out    = CNMF(cnmf_input)

    jaccard_out = JACCARD(cnmf_out)

    GEP_ANALYSIS(jaccard_out.collect())
}