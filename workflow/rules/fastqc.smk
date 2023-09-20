rule fastqc:
    input:
        "data/fastq/illumina/{state}/{accession}_{direction}_{state}.fastq.gz"
    output:
        html="data/qc/fastqc/{state}/{accession}_{direction}_{state}.html",
        zip="data/qc/fastqc/{state}/{accession}_{direction}_{state}_fastqc.zip" # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params:
        extra = "--quiet"
    log:
        "logs/fastqc/{state}/{accession}_{direction}_{state}.log"
    threads: 1
    resources:
        mem_mb = 4000
    wrapper:
        "v2.6.0/bio/fastqc"


rule fastqc_all:
    input:
        expand("data/qc/fastqc/{state}/{accession}_{direction}_{state}.html",
            accession=accessions,
            direction=[1, 2],
            state=['raw', 'trimmed'])
    resources:
        runtime = 5
