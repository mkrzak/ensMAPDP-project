
preprocess <- function(D, filter, normalize){

  sce <- SingleCellExperiment(assays = list(counts = as.matrix(D)), colData = colnames(D))
  rowData(sce)$feature_symbol <- rownames(sce)
  
  if(filter==TRUE){
    sce <- scater::calculateQCMetrics(sce)
    rowData(sce)$ave.counts <- scater::calcAverage(sce, exprs_values = "counts", use_size_factors=FALSE)
    to.keep <- rowData(sce)$ave.counts > 0
    sce <- sce[to.keep,]
  }else if(filter==FALSE){
   sce <- sce 
  }
  
  if(normalize==TRUE){
    
    set.seed(100)
    if(dim(sce)[2]<500){
      min.size=50   
    } else {
      min.size=200   
    }
    
    clusters <- scran::quickCluster(sce, min.size=min.size, min.mean=0.1, method="igraph")
    sce <- scran::computeSumFactors(sce, cluster=clusters, min.mean=0.1)
    sce <- scater::normalize(sce, return_log = FALSE)
    counts(sce) <- normcounts(sce)
    
  }else if(normalize==FALSE){
    sce <- sce
  }

  D.prep <- counts(sce)
  
  
  return(D.prep)
  
  
}