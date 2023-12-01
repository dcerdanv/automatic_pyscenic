rule run_arboreto:
    input:
        loom_matrix = get_params('pyscenic', 'loom_matrix'),
        tfs = get_params('pyscenic', 'tfs_file')
    output:
        f"{OUTDIR}/{{seed}}/grn_arboreto_{{seed}}.tsv"
    threads:
        get_resource('pyscenic', 'threads')
    resources:
        mem_mb = get_resource('pyscenic', 'mem_mb'),
        runtime = get_resource('pyscenic', 'runtime')
    params:
        method = get_params('pyscenic', 'method'),
        num_workers = get_params('pyscenic', 'num_workers'),
        extra = get_params('pyscenic', 'extra'),
        seed = f"{{seed}}"
    log:
        log_out = f"{LOGDIR}/{{seed}}/grn_arboreto_{{seed}}.out",
        log_err = f"{LOGDIR}/{{seed}}/grn_arboreto_{{seed}}.err"
    conda:
        '../envs/pyscenic.yaml'
    shell: """
        arboreto_with_multiprocessing.py {input.loom_matrix} {input.tfs} --method {params.method} --output {output} --num_workers {params.num_workers} --seed {params.seed} {params.extra} 2>> {log.log_err} 1>> {log.log_out}
    """


def get_all_input(wildcards):

    all_input = []

    for seed in seeds['seed_ID']:

        all_input += [f"{OUTDIR}/{seed}/grn_arboreto_{seed}.tsv"]

    return all_input