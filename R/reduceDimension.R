
#Create tSNE projections
###########################################################
#, nrDims

reduceDimension <- function(D.sub, dim.method, nrProjections){
    
  library(doParallel)
  
        myfunc <- function(x){
        
          if(dim.method=="tSNE"){
            library(scater)
            temp_sce <- SingleCellExperiment(assays = list(counts = D.sub))
            assay(temp_sce, "log2") <- log2(counts(temp_sce) + 1)
            temp_sce <- scater::runTSNE(temp_sce, ncomponents = 3, ntop=dim(temp_sce)[1], exprs_values = "log2", rand_seed = NULL) #perplexity is not used
            temp_proj=as.data.frame(temp_sce@reducedDims$TSNE)
          }
          
          else if(dim.method=="UMAP"){
            library(umap)
            library(reticulate)
            D.sub <- log2(D.sub + 1)
            temp_proj = umap(t(D.sub), method="umap-learn", n_components=2)
            temp_proj = temp_proj$layout
          }

        return(temp_proj)
    }
    
    #Do pararell computing
    no_cores <- detectCores() - 1
    cl <- makeCluster(no_cores-1)
    doParallel::registerDoParallel(cl)
    D.proj <- foreach(i=1:nrProjections) %dopar% myfunc(D.sub)
    stopCluster(cl)
    
    
    # Write tSNE to files
    dir.create(paste0(output.path, "/output"))
    dir.create(paste0(output.path, "/output/Proj"))
    for(i in 1:length(D.proj)){
        write.table(D.proj[[i]], file= paste0(output.path, "/output/Proj/", paste0("proj",i,".csv")), sep = ",", row.names = FALSE)#, col.names = NA)
    }
    
    return(D.proj)
    
    
}