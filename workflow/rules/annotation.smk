rule get_genome:
    output:
        "data/annotation/genome.fa"
    shell:
        "wget -q -O - https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/GRCh38.p14.genome.fa.gz | gunzip > {output}"


rule get_annotation:
    output:
        "data/annotation/annotation.gtf"
    shell:
        "wget -q -O - https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.annotation.gtf.gz | gunzip > {output}"


rule sort_gtf:
    input: 
        "{file}.gtf"
    output:
        "{file}_sorted.gtf"
    conda:
        "../envs/bedtools.yaml"
    shell:
        "bedtools sort -i {input} > {output}"


rule get_transcripts:
    output:
        "data/annotation/transcripts.fa"
    shell:
        "wget -q -O - https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/gencode.v44.transcripts.fa.gz | gunzip > {output}"
