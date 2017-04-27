start.time <- Sys.time()
require(vegan)

adonis_runner <- function(otutable,mapfile,outputname,meth){
	MYdata <- read.table(otutable,header = T, sep = "\t", check.names = F, row.names =1, comment.char= "", skip =1,quote="")
	MYmetaEF <- read.table(mapfile,header = T, sep = "\t", check.names = F, comment.char= "")
	adonis_out <- lapply(2:ncol(MYmetaEF),function(i){
		name_vec <- as.vector(MYmetaEF[[1]])[which(!is.na(MYmetaEF[[i]]))]		# Select sampleIDs that have no NAs for the defined metavariable
		sub_MYdat <- subset(MYdata, select=name_vec)							# Subset the original untransformed data by selecting samples with no NAs
		MYarray2 <- t(sub_MYdat)												# Transpose the subset data-matrix
		set.seed(123)
		adon <- tryCatch(adonis(MYarray2 ~ MYmetaEF[[i]], data=MYmetaEF, method=meth, permutations = 1000, autotransform=T),error=function(e) NA)
    		results <- tryCatch(adon$aov.tab,error=function(e) NA)
    		r2 <- tryCatch(results[1,5],error=function(e) NA)
    		pvalue <- tryCatch(results[1,6],error=function(e) NA)
		return(c(colnames(MYmetaEF)[i],r2,pvalue))
	})
	final_result <- do.call("rbind",adonis_out)
	colnames(final_result) <- c("parameter", "R2", "pvalue")
	suppressWarnings(write.table(as.matrix(final_result),file=outputname,sep="\t",append = TRUE,col.names=TRUE,row.names=FALSE,quote=FALSE))
}


#Rscript adonis_loop.R otu_table_rarefied.txt mapping_file.txt adnois_results.txt canberra
argv <- commandArgs(TRUE)
adonis_runner(argv[1],argv[2],argv[3],argv[4])
print (Sys.time() - start.time)
