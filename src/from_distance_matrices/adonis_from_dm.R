require(vegan)

dataframe_filter <- function(namearrange,meta,MYdata){
	rearrlist <- lapply(namearrange,function(x) eval(parse(text = paste("subset(MYdata,",meta, "==x)"))))
	newdataf <- do.call("rbind", rearrlist)
	return (newdataf)

}

adonis_runner <- function(dminp,mapfile,outputname){
	dmat <- read.table(dminp,header = T, sep = "\t", check.names = F, comment.char= "",row.names=1)
	MYmetaEF <- read.table(mapfile,header = T, sep = "\t", check.names = T,comment.char= "")
	#MYmetaEF <- cbind(MYmetaEF[,1],exp(MYmetaEF[,2:7]))									# This can be commented out if we are not exponentiating the the data
	#colnames(MYmetaEF) <- c("X.SampleID",colnames(MYmetaEF)[2:ncol(MYmetaEF)])			# This line need also be commmented out in case line above is commented
	namearrange <- colnames(dmat)
	meta <- "X.SampleID"
	MYmetaEF <- dataframe_filter(namearrange,meta,MYmetaEF)
	adonis_out <- lapply(2:ncol(MYmetaEF),function(i){
		adon <- adonis(as.dist(dmat) ~ MYmetaEF[[i]], data=MYmetaEF, permutations = 1000, autotransform=T)
		results <- adon$aov.tab
		return(c(colnames(MYmetaEF)[i],results[1,5],results[1,6]))	
	})
	final_result <- do.call("rbind",adonis_out)
	colnames(final_result) <- c("parameter", "R2", "pvalue")
	suppressWarnings(write.table(as.matrix(final_result),file=outputname,sep="\t",append = TRUE,col.names=TRUE,row.names=FALSE,quote=FALSE))
}


setwd('/Users/alifaruqi/Desktop/Projects/Development_Tools/Github_Scripts/adonis_loop/src/from_distance_matrices')

adonis_runner("bray_curtis_dm.txt","metadata_map.txt","bray_adonis.txt")
adonis_runner("canberra_dm.txt","metadata_map.txt","canberra_adonis.txt")
adonis_runner("unweighted_unifrac_dm.txt","metadata_map.txt","unweighted_unifrac_adonis.txt")
adonis_runner("weighted_unifrac_dm.txt","metadata_map.txt","weighted_unifrac_adonis.txt")


##### No to fix
start.time <- Sys.time()
#Rscript adonis_loop.R otu_table_rarefied.txt mapping_file.txt adnois_results.txt canberra
argv <- commandArgs(TRUE)
adonis_runner(argv[1],argv[2],argv[3],argv[4])
print (Sys.time() - start.time)
