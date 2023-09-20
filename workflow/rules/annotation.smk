rule get_genome:
    output:
        "data/annotation/genome.fa"
    shell:
        "wget -q -O - https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_44/GRCh38.p14.genome.fa.gz | gunzip > {output}"