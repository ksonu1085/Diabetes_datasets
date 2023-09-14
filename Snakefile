__author__ = "Christoph Engelhard"
__email__ = "christoph.andreas.engelhard@regionh.dk"

import pandas as pd


# configuration
runinfo = pd.read_csv("configuration/runinfo.csv")
accessions = runinfo.loc[:, "accession"].tolist()


# include
include: "workflow/rules/sra.smk"
include: "workflow/rules/cutadapt.smk"
