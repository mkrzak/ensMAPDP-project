install.packages("doParallel")
install.packages("umap")
install.packages("reticulate")
install.packages("R.matlab")
install.packages("stringr")
install.packages("Matrix")
install.packages("DelayedMatrixStats")
install.packages("ggplot2")


#install.packages("mclust") #not sure


if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("scater")
BiocManager::install("SingleCellExperiment")
