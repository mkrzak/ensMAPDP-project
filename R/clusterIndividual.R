
#Cluster individual projections
###########################################################

clusterIndividual <- function(D.proj, N0, pB0){

    MAPDP <- function(name, N0, pB0) {
        setVariable(matlab, filebase=name)
        setVariable(matlab, N0=N0)
        setVariable(matlab, pB0=pB0)
        evaluate(matlab, "ClusteringContinData")
        return(list(getVariable(matlab, "inferredClusters")$inferredClusters))
    }


    library(R.matlab)
    options(matlab=matlab.path)
    Matlab$startServer(port=9999)
    matlab <- Matlab(port=9999)
    setVerbose(matlab, 2)
    check_open_matlab <- open(matlab)
    evaluate(matlab, paste0("cd ", program.path, "/MATLAB"))


    # source(paste0(program.path, "/R/run_matlab.R"))

    D.ind.clust=list()
    for(i in 1:length(D.proj)){
        name=file.path(output.path, "output/Proj", paste0("proj",i,".csv"))
        D.ind.clust[i]=MAPDP(name, N0, pB0)
        rownames(D.ind.clust[[i]]) <- rownames(D.proj[[i]])
    }

    close(matlab)

    system("rm MatlabServer.m")
    system("rm InputStreamByteWrapper.class")
    return(D.ind.clust)

}

