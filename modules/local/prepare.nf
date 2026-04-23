
process PREPARE {
    tag "prepare"

    input:
    path counts_file

    output:
    path "prepare_out"

    script:
    """
    python ${projectDir}/scripts/prepare.py \
        -c ${counts_file} \
        --output-dir prepare_out \
        --numgenes ${params.numgenes}
    """
}
