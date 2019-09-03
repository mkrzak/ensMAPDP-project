plotResult <- function(projection, clustering, title){

  df=data.frame(projection,clustering)

  library(ggplot2)
  p <- ggplot(df, aes(x=df[,1], y=df[,2], color=factor(clustering))) + geom_point()
  p <- p + labs(color = "clustering")
  p <- p + ggtitle(title) 
  p <- p + theme(plot.title = element_text(size = 15))
  p <- p + labs(x="Dimension 1", y= "Dimension 2")
   
  return(p)
  
}
