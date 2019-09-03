
#Ensemble clusterings
###########################################################

clusterEnsemble <- function(D.ind.clust){
    
    if(length(D.ind.clust)==1){
      warning("Provide more than one clustering to perform ensemble", call. = FALSE)
    }else{
      source(paste0(program.path, "/R/run_SAFE.R"))
      D.ind.clust_mat=t(sapply(D.ind.clust, unlist))
      D.ens.clust = run_SAFE(D.ind.clust_mat, k_max = NULL, MCLA = TRUE, HGPA = FALSE, CSPA = FALSE, cspc_cell_max = NULL, SEED = 123)
      D.ens.clust=D.ens.clust$optimal_clustering
      names(D.ens.clust) <- rownames(D.ind.clust[[1]])
      
      # library("diceR")
      # D.ind.clust_mat=sapply(D.ind.clust, unlist)
      # D.ens.clust=diceR::majority_voting(D.ind.clust_mat, is.relabelled = FALSE)
      
      # library("diceR")
      # D.ind.clust_mat=sapply(D.ind.clust, unlist)
      # D.ens.clust=diceR::k_modes(D.ind.clust_mat, is.relabelled = FALSE, seed=1)

      
      # library("IntClust") #Error: $ operator is invalid for atomic vectors 
      # D.ind.clust_mat=sapply(D.ind.clust, unlist)
      # ha=IntClust::EnsembleClustering(D.ind.clust, type="clusters")
      
      # library("clue") #uses only object from hclust
      # as.cl_ensemble()
      # clue::cl_ensemble()
      # D.ind.clust_mat=sapply(D.ind.clust, unlist)
      # A=as.cl_ensemble(D.ind.clust)
      # is.cl_ensemble(D.ind.clust)

      
      return(D.ens.clust)
    }
    
}

