# About The Cancer Genome Atlas

> The Cancer Genome Atlas (TCGA) is a comprehensive and coordinated effort to accelerate our understanding of the molecular basis of cancer through the application of genome analysis technologies, including large-scale genome sequencing - [http://cancergenome.nih.gov/](http://cancergenome.nih.gov/). 

[Our team](https://github.com/orgs/RTCGA/people) converted selected datasets from this study into few separate packages that are hosted on Bioconductor. These R packages make selected datasets easier to access and manage. Data sets in RTCGA packages are large and cover complex relations between clinical outcomes and genetic background.

To use RTCGA install package with instructions from it's [Bioconductor home page](https://www.bioconductor.org/packages/RTCGA/)


```{r}

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")

BiocManager::install("RTCGA")
# data packages can be installed with
BiocManager::install("RTCGA.clinical")
BiocManager::install("RTCGA.rnaseq")
```{r}