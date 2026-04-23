
process GEP_ANALYSIS {
    tag "${params.dataset_name}"

    input:
    path jaccard_dirs

    output:
    path "GEP_results"

    script:
    def k_values_csv = (params.k_min..params.k_max).step(params.k_step).join(',')

    """
    mkdir -p merged_input
    for d in ${jaccard_dirs}; do
        cp -r \$d/* merged_input/
    done

    mkdir -p GEP_results

    Rscript --vanilla ${projectDir}/scripts/GEP_analysis.R \
        merged_input/ \
        ${params.dataset_name} \
        GEP_results/ \
        ${k_values_csv} \
        ${params.check_for_rescue ? 1 : 0}
    """
}