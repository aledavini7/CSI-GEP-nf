
process CNMF {
    tag "k=${k}"

    input:
    tuple path(prepare_dir), val(k)

    output:
    tuple path("cnmf_out"), val(k)

    script:
    """
    python ${projectDir}/scripts/cNMF.py \
        --output-dir ${prepare_dir} \
        --components ${k} \
        --n-iter ${params.n_iter}

    mkdir -p cnmf_out
    cp -r ${prepare_dir}/* cnmf_out/
    """
}

