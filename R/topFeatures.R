
topFeatures <- function(D.prep, nrFeatures){
    vars <- DelayedMatrixStats::rowVars(log1p(D.prep))
    names(vars) <- rownames(D.prep)
    vars <- sort(vars, decreasing = TRUE)
    D.ord=D.prep[names(vars),]
    D.sub=D.ord[1:nrFeatures, ]
    return(D.sub)
    }

