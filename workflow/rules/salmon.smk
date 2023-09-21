rule salmon_index:
    input:
        "data/annotation/transcripts.fa"
    output:
        directory("data/index/salmon/")
    threads: 
        16
    conda:
        "../envs/salmon.yaml"
    shell:
        "salmon index --gencode -i {output} -t {input} -p {threads}"


rule salmon_pe:
    input:
        fq1 = "data/fastq/illumina/trimmed/{accession}_1_trimmed.fastq.gz",
        fq2 = "data/fastq/illumina/trimmed/{accession}_2_trimmed.fastq.gz", 
        idx = "data/index/salmon/"
    output:
        aln="data/salmon/{accession}/quant.sf",
    threads:
        16
    shell:
        "salmon quant --gcBias --seqBias --numGibbsSamples 25 -i {input} -l A -1 {input.fq1} -2 {input.fq2} -p {threads} --validateMappings -o data/salmon/{wildcards.accession}"


rule salmon_all:
    input:
        expand("data/salmon/{accession}/quant.sf", 
            accession=accessions)
