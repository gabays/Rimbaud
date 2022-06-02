# Author: JB Camps (tiny stuff by S. Gabay)
#title: Rolling Rimbaud

#working directory
setwd("~/GitHub/stylometrie/Rimbaud")

# Load data
dists = read.csv("SuperStyl/FINAL_PREDICTIONS.csv")

# Get average point
x = lapply(strsplit(sub(pattern = "^[^_]+\\_", "", dists[,2]), "-"), as.numeric)
x = lapply(x, mean)
#labels = read.csv("subdivisions.csv")

#colors
couls = matrix(ncol = 1, nrow = ncol(dists)-3, data=c(
  "grey",  "palegreen2", "#FB9A99", # lt pink
  "green", "red", "gold1"
)[1:(ncol(dists)-3)], dimnames = list(colnames(dists)[4:ncol(dists)], "color"))

#Plot and save
png(paste("SuperStyl/rolling.png"), height = 3000, width = 5000, res = 400)
for(i in 4:ncol(dists)){
  if(i == 4){
    plot(x, smooth(dists[,4], kind = "3RSR"), type="l", ylim = c(round(min(dists[, 4:ncol(dists)]), digits = 1),1), lty=1, ylab = "decision function", xlab = "tokens", col=couls[colnames(dists)[i],], ljoin=3)
  }
  else{
    lines(x, smooth(dists[,i], kind = "3RSR"), col=couls[colnames(dists)[i],], ljoin=3)
  }
}

legend(1000,1, legend=colnames(dists)[4:ncol(dists)], col=couls[colnames(dists[4:ncol(dists)]),], lty=1, ncol=1, cex = 0.5)
dev.off()

#abline(v=labels[,2], col="grey", lty=2)
#text(x = labels[,2], y = 0.5,  labels[,1], srt=90, cex=0.8)
