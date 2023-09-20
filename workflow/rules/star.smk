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
