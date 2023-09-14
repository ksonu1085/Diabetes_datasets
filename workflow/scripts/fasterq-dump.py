import os
import tempfile
from snakemake.shell import shell


log = snakemake.log_fmt_shell(stdout=True, stderr=True)


# outdir
outdir = os.path.dirname(snakemake.output[0])
outdir = f"{outdir}"


# resources
mem_bytes = snakemake.resources.mem_mb * 10**6
disk_bytes = snakemake.resources.disk_mb * 10**6


# compression
compress = ""

for output in snakemake.output:
    out_name, out_ext = os.path.splitext(output)
    compress += f"pigz -p {snakemake.threads} {out_name}; "


# run shell
with tempfile.TemporaryDirectory(dir=outdir) as tmpdir:
    shell(
        "(fasterq-dump "
        "    {snakemake.input} "
        "    -x "
        "    --temp {tmpdir} "
        "    --threads {snakemake.threads} "
        "    --skip-technical "
        "    --disk-limit-tmp 64000000000 "
        "    --disk-limit {disk_bytes} "
        "    --mem {mem_bytes} "
        "    --outdir {outdir}; "
        "    mv {outdir}/{snakemake.wildcards.accession}_1.fastq {outdir}/{snakemake.wildcards.accession}_1_raw.fastq; "
        "    mv {outdir}/{snakemake.wildcards.accession}_2.fastq {outdir}/{snakemake.wildcards.accession}_2_raw.fastq; "
        "{compress}"
        ") {log}"
    )
