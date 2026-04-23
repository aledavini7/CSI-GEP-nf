
process JACCARD {
    tag "k=${k}"

    input:
    tuple path(cnmf_dir), val(k)

    output:
    path "jaccard_out_k${k}"

    script:
    """
    mkdir -p ${cnmf_dir}/results

    Rscript --vanilla ${projectDir}/scripts/Jaccard.R ${k} ${cnmf_dir}/

    mkdir -p jaccard_out_k${k}
    cp -r ${cnmf_dir}/* jaccard_out_k${k}/
    """
}