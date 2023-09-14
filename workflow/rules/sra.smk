rule prefetch:
    output:
        directory("data/fastq/illumina/sra/{accession}")
    log:
        "log/prefetch/prefetch_{accession}.log"
    conda:
        "../envs/sra-tools.yaml"
    shell:
        "prefetch {wildcards.accession} -O data/fastq/illumina/sra/ 2> {log}"


rule fasterqdump_pe:
    input:
        directory("data/fastq/illumina/sra/{accession}")
    output:
        "data/fastq/illumina/raw/{accession}_1_raw.fastq.gz",
        "data/fastq/illumina/raw/{accession}_2_raw.fastq.gz"
    log:
        "log/fasterq-dump/fasterq-dump_{accession}.log"
    threads:
        5
    conda:
        "../envs/sra-tools.yaml"
    resources:
        runtime = 120,
        mem_mb = 4000,
        disk_mb = 250000
    script:
        "../scripts/fasterq-dump.py"


rule dump_all:
    input:
        expand("data/fastq/illumina/raw/{accession}_{direction}_raw.fastq.gz",
            accession=accessions,
            direction=[1, 2])
    resources:
        runtime = 5
