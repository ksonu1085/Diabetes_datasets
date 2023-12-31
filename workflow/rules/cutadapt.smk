
rule cutadapt_pe:
    input:
        reads1 = "data/fastq/illumina/raw/{accession}_1_raw.fastq.gz",
        reads2 = "data/fastq/illumina/raw/{accession}_2_raw.fastq.gz"
    output:
        reads1 = "data/fastq/illumina/trimmed/{accession}_1_trimmed.fastq.gz",
        reads2 = "data/fastq/illumina/trimmed/{accession}_2_trimmed.fastq.gz",
        qc = "data/qc/cutadapt/{accession}.cutadapt.json"
    log:
        "log/cutadapt/{accession}.log"
    params:
        adapter_fwd = "AGATCGGAAGAGCACACGTCTGAACTCCAGTCA",
        adapter_rev = "AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT"
    threads:
        5
    conda:
        "../envs/cutadapt.yaml"
    shell:
        "cutadapt \
            -q 28 \
            -m 30 \
            -a {params.adapter_fwd} \
            -A {params.adapter_rev} \
            -o {output.reads1} \
            -p {output.reads2} \
            -j {threads} \
            --json={output.qc} \
            {input.reads1} {input.reads2} \
            > {log}"


rule cutadapt_all:
    input:
        expand("data/fastq/illumina/trimmed/{accession}_{direction}_trimmed.fastq.gz",
            accession=accessions,
            direction=[1, 2])
    resources:
        runtime = 5
