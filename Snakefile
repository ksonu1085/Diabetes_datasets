__author__ = "Sonu Kumari"
__email__ = "Ksonu1085@gmail.com"

import pandas as pd


# configuration
runinfo = pd.read_csv("configuration/runinfo.csv")
accessions = runinfo.loc[:, "accession"].tolist()

wildcard_constraints:
    state = "raw|trimmed",
    direction = "1|2"

# include
include: "workflow/rules/sra.smk"
include: "workflow/rules/cutadapt.smk"
include: "workflow/rules/fastqc.smk"
include: "workflow/rules/star.smk"
include: "workflow/rules/annotation.smk"
