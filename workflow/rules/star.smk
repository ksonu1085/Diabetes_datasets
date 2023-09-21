rule star_index:
    input:
        fasta="data/annotation/genome.fa",
    output:
        directory("data/index/star/"),
    message:
        "Testing STAR index"
    threads: 16
    params:
        extra="",
    log:
        "logs/star_index.log",
    wrapper:
        "v2.6.0/bio/star/index"


rule star_pe_multi:
    input:
        fq1=["data/fastq/illumina/trimmed/{accession}_1_trimmed.fastq.gz"],
        fq2=["data/fastq/illumina/trimmed/{accession}_2_trimmed.fastq.gz"], 
        idx="data/index/star/"
    output:
        aln="data/star/{accession}/pe_aligned.sam",
        log="logs/star/{accession}/Log.out",
        sj="data/star/{accession}/SJ.out.tab",
        unmapped=["data/star/{accession}/unmapped.1.fastq.gz","data/star/{accession}/unmapped.2.fastq.gz"],
    log:
        "logs/star/{accession}.log",
    params:
        # optional parameters
        extra="",
    threads: 16
    wrapper:
        "v2.6.0/bio/star/align"


rule sort_by_coord:
    input:
        "data/star/{accession}/pe_aligned.sam"
    output:
        "data/star/{accession}/pe_aligned_sorted.bam"
    threads:
        8
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools sort -l 4 -@ {threads} -o {output} {input}"


rule index_bam:
    input:
        "data/star/{accession}/pe_aligned_sorted.bam"
    output:
        "data/star/{accession}/pe_aligned_sorted.bam.bai"
    threads:
        4
    conda:
        "../envs/samtools.yaml"
    shell:
        "samtools index -b -@ {threads} -o {output} {input}"


rule star_all:
    input:
        expand("data/star/{accession}/pe_aligned_sorted.bam.bai", 
            accession=accessions)
