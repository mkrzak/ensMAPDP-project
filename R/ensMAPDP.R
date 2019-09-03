
source(paste0(program.path, "/R/preprocess.R"))
source(paste0(program.path, "/R/topFeatures.R"))
source(paste0(program.path, "/R/reduceDimension.R"))
source(paste0(program.path, "/R/clusterIndividual.R"))
source(paste0(program.path, "/R/clusterEnsemble.R"))
source(paste0(program.path, "/R/plotResult.R"))

ensMAPDP <- function(D, filter, normalize, nrFeatures, dim.method, nrProjections, N0, pB0){
  
    D.prep <- preprocess(D, filter=filter, normalize=normalize)
    D.sub  <- topFeatures(D.prep, nrFeatures=nrFeatures)
    D.proj <- reduceDimension(D.sub, dim.method=dim.method, nrProjections=nrProjections)
    D.ind.clust <- clusterIndividual(D.proj, N0=N0, pB0=pB0) 
    D.ens.clust <- clusterEnsemble(D.ind.clust)
    return(D.ens.clust)
}

