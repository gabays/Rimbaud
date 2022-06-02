### ACH

hcaPlot = function(x,  main="Plot", k, size, color, features, distance, culling){
  plot(x, main=main, which.plots = 2)
  factoextra::fviz_dend(x,
                        ylab=paste("Distance: ", distance, " ||  Words selection: ", culling, " || Clustering: Ward \n Agglomerative coefficient =", myHCA.AC, "|| Features: ", features),
                        k=k, # I want two clusters
                        rect = TRUE,
                        k_colors = rep("black",2), #lines in black
                        labels_track_height = size, # size if the rectangle
                        label_cols = color, #using colors
                        horiz=T,
                       
  )
}

### Normalisations
# Taken from Camps & Cafiero 2019

relativeFreqs = function(x){
  # Relative frequencies
  for(i in 1:ncol(x)){
    x[,i] = x[,i]/sum(x[,i])
  }
  return(x)
}
# Z-scores
ZTransf = function(x){
  for(i in 1:nrow(x)){
    x[i,] = ( x[i,] - mean(x[i,]) )  / sd(x[i,])
  }
  return(x)
}

normalisations = function(x){
  # Z-transformation  
  x = ZTransf(x)
  
  # Vector length normalisation
  for(i in 1:ncol(x)){
    x[,i] = x[,i] / sqrt(sum(x[,i]^2))
  }
  return(x)
}


### MinMax metric (Koppel  and  Winter  2014))
# Taken from Camps & Cafiero 2019
MinMax =
  function(x){
    myDist = matrix(nrow = ncol(x),ncol = ncol(x), dimnames = list(colnames(x),colnames(x)))
    for(i in 1:ncol(x)){
      for(j in 1:ncol(x)){
        min = sum(apply(cbind(x[,i],x[,j]), 1, min))
        max = sum(apply(cbind(x[,i],x[,j]), 1, max))
        resultat = 1 - (min / max)
        myDist[i,j] = resultat
      }
    }
    return(myDist)
  }


### counting affixes.
# Taken from Camps & Cafiero 2019
aggrAndClean = function(x){
  # aggregate
  aggr = aggregate(x~rownames(x),FUN = sum)
  # cleaning
  x = as.matrix(aggr[,-1])
  rownames(x) = aggr[,1]
  return(x)
}

countAffixes = function(x){
  # Prefixes
  prefs = x
  # Remove words shorter than 3+1 chars
  prefs = prefs[stringr::str_length(rownames(prefs)) > 3,]
  # Extract the first three chars as new rownames
  rownames(prefs) = paste("$", substr(rownames(prefs), 1, 3), sep = "")
  prefs = aggrAndClean(prefs)
  
  # Space prefixes
  spPrefs = x 
  rownames(spPrefs) = paste("_", substr(rownames(spPrefs), 1, 2), sep = "")
  spPrefs = aggrAndClean(spPrefs)
  
  # Suffixes
  sufs = x
  sufs = sufs[stringr::str_length(rownames(sufs)) > 3,]
  rownames(sufs) = paste(stringr::str_sub(rownames(sufs), -3), "^", sep = "")
  sufs = aggrAndClean(sufs)
  
  # Space suffixes
  spSufs = x
  rownames(spSufs) = paste(stringr::str_sub(rownames(spSufs), -2), "_", sep = "")
  spSufs = aggrAndClean(spSufs)
  
  results = rbind(prefs, spPrefs, sufs, spSufs)
  
  return(results)
}

### Feature selection (Moisl 2011).
# Taken from Camps & Cafiero 2019

selection = function(x, z = 1.96){
  
  # Conversion to probabilities
  probs = relativeFreqs(x)
  
  # Prepare output
  results = matrix(nrow = nrow(probs), ncol = 4, dimnames = list(rownames(probs), c('freq', 'mean prob', 'sample size necessary', 'passes')))
  results = as.data.frame(results)
  results[,1] = rowSums(x)
  results[,2] = rowMeans(probs)
  
  for (i in 1:nrow(probs)){
    var = probs[i,]
    # hist(probs[i,])
    # Calculates mirror-image to compensate for non normality
    mirror = ( max(var) + min(var) ) - var
    var = c(var,mirror)
    # e as function of sigma
    e = 2 * sd(var)
    results[i,3] = mean(var) * (1 - mean(var)) * (z / e )^2 
  }
  
  # And now, mark as false all the rows that would necessit bigger sample than available
  results[,4] = results[,3] <= min(colSums(x))
  
  return(results)
}

get_colors = function(x){
  labels_color = vector(length = length(myHCA$order.lab))
  if (x == "control"){
    labels_color[grep("cop", myHCA$order.lab)] = "blue"
    labels_color[grep("her", myHCA$order.lab)] = "red"
    labels_color[grep("diex", myHCA$order.lab)] = "green"
  }
  if (x == "research"){
    labels_color[grep("nouv", myHCA$order.lab)] = "blue"
    labels_color[grep("rimb", myHCA$order.lab)] = "red"
    labels_color[grep("verl", myHCA$order.lab)] = "green"
  }

  return(labels_color)
}

### Robustness
# Taken from Camps & Cafiero 2019

robustnessChecks = function(data, refCAH, k = "10"){
  # Get classes from the reference CAH
  refCAHClasses = cutree(refCAH, k = k)
  # Prepare results
  results = matrix(ncol = 3, nrow = 0, dimnames = list(NULL, c("N", "CPAuteurs", "CPReference")))
  for (i in list(
    seq(0, 1, 0.001),
    seq(0, 1, 0.01),
    seq(0, 1, 0.1),
    seq(0, 1, 0.25),
    seq(0, 1, 0.5),
    seq(0, 0.5, 0.25),
    seq(0, 1, 1)) ) {
    # First, get the cutoffs: first 1000-quantile, first 100-quantile, first decile, all
    selec = quantile(rowSums(data), probs = i)
    selec = selec[length(selec) - 1]
    
    myData = data[rowSums(data) >= selec, , drop = FALSE]
    myData = normalisations(myData)
    myCAH = cluster::agnes(t(myData), metric = "manhattan", method="ward")
    
    # Classes as per alledged author
    expected = sub("_.*", "", rownames(myHCA$data))
    # Cluster purity
    classes = cutree(myHCA, k = k)
    
    N = nrow(myData)
    purity = NMF::purity(as.factor(classes), expected)
    #NMF::entropy(as.factor(classes), expected)
    purityRef = NMF::purity(as.factor(classes), as.factor(refCAHClasses))
    #Rand = mclust::adjustedRandIndex(classes, refCAHClasses)
    
    MF = paste(round(100 - as.numeric(sub("%", "", names(selec))), digits = 2), "%", sep = "")
    
    #localRes = matrix(data = c(N, purity, purityRef, Rand), nrow = 1, ncol = 4, dimnames = list(MF, NULL))
    localRes = matrix(data = c(N, purity, purityRef), nrow = 1, ncol = 3, dimnames = list(MF, NULL))
    results = rbind(results, localRes)
  }
  return(results)
}

#updated version of tokenizer: modification of the regex for splitting (adding numbers)
#origin: stylo package

txt.to.words2 = function(input.text,
                        splitting.rule = NULL,
                        preserve.case = FALSE) {
#


  # since the function can be applied to lists and vectors,
  # we need to define an internal function that will be applied afterwards
  wrapper = function(input.text = input.text, splitting.rule = splitting.rule,
                        preserve.case = preserve.case) {

  # converting characters to lowercase if necessary
  if (!(preserve.case)){
      input.text = tryCatch(tolower(input.text),
                            error=function(e) NULL)
      if(is.null(input.text) == TRUE) {
        input.text = "empty"
        cat("turning into lowercase failed!\n")
      }
  }
     # if no custom splitting rule was detected...
    if(length(splitting.rule) == 0 ) {
      # splitting into units specified by regular expression; here,
      # all sequences between non-letter characters are assumed to be words:
      splitting.rule = paste("[^A-Za-z0-9",
          # Latin supplement (Western):
          "\U00C0-\U00FF",
          # Latin supplement (Eastern):
          "\U0100-\U01BF",
          # Latin extended (phonetic):
          "\U01C4-\U02AF",
          # modern Greek:
          "\U0386\U0388-\U03FF",
          # Cyrillic:
          "\U0400-\U0481\U048A-\U0527",
          # Hebrew:
          "\U05D0-\U05EA\U05F0-\U05F4",
          # Arabic/Farsi:
          "\U0620-\U065F\U066E-\U06D3\U06D5\U06DC",
          # extended Latin:
          "\U1E00-\U1EFF",
          # ancient Greek:
          "\U1F00-\U1FBC\U1FC2-\U1FCC\U1FD0-\U1FDB\U1FE0-\U1FEC\U1FF2-\U1FFC",
          # Coptic:
          "\U03E2-\U03EF\U2C80-\U2CF3",
          # Georgian:
          "\U10A0-\U10FF",
          # Japanese (Hiragana)
          "\U3040-\U309F",
          # Japanese (Katagana):
          "\U30A0-\U30FF",
          # Japanese repetition symbols:
          "\U3005\U3031-\U3035",
          # CJK Unified Ideographs:
          "\U4E00-\U9FFF",
          # CJK Unified Ideographs Extension A:
          "\U3400-\U4DBF",
          # Hangul (Korean script):
          "\UAC00-\UD7AF",
          "]+",
          sep="")
      tokenized.text = c(unlist(strsplit(input.text, splitting.rule)))
    # if custom splitting rule was indicated:
    } else {
      # sanity check
      if(length(splitting.rule) == 1) {
        # just in case, convert to characters
        splitting.rule = as.character(splitting.rule)
        # splitting into units specified by custom regular expression
        tokenized.text = c(unlist(strsplit(input.text, splitting.rule)))
      } else {
        stop("Wrong splitting regexp")
      }
    }
  # getting rid of emtpy strings
  tokenized.text = tokenized.text[nchar(tokenized.text) > 0]

  }



        # the proper procedure applies, depending on what kind of data
        # is analyzed

        # test if the dataset has a form of a single string (a vector)
        if(is.list(input.text) == FALSE) {
                # apply an appropriate replacement function
                tokenized.text = wrapper(input.text = input.text,
                        splitting.rule = splitting.rule,
                        preserve.case = preserve.case)
                # if the dataset has already a form of list
        } else {
                # applying an appropriate function to a corpus:
                tokenized.text = lapply(input.text, wrapper,
                        splitting.rule = splitting.rule,
                        preserve.case = preserve.case)
                class(tokenized.text) = "stylo.corpus"
        }



# outputting the results
return(tokenized.text)
}

#updated version of ngram tokenizer
#origin: stylo package


to_c3grams = function(tokenized.text, features = "c", ngram.size = 3){
  
  # since the function can be applied to lists and vectors,
  # we need to define an internal function that will be applied afterwards
  wrapper = function(tokenized.text, features = "w", ngram.size = 1){    
    
    #
    # Splitting the text into chars (if "features" was set to "c")
    if(features == "c") {
      sample = paste(tokenized.text, collapse=" ")
      sample = unlist(strsplit(sample,""))
      # replacing  spaces with underscore
      # it is a very proc time consuming task; thus, let's drop it
      #    sample = gsub(" ","_",sample)
    } else {
      # otherwise, leaving the original text unchanged
      sample = tokenized.text
    }
    # 2. making n-grams (if an appropriate option has been chosen):
    if(ngram.size > 1) {
      sample = make.ngrams(sample, ngram.size = ngram.size)
      #    # getting rid of additional spaces added around chars
      #    # it is a very proc time consuming task; thus, let's drop it
      #    if(features == "c") {
      #      sample = gsub(" ","",sample)
      #    }
    }
    #
    return(sample)
  }
  
  
  
  # the proper procedure applies, depending on what kind of data 
  # is analyzed
  
  # test if the dataset has a form of a single string (a vector)
  if(is.list(tokenized.text) == FALSE) {
    # apply an appropriate replacement function
    sample = wrapper(tokenized.text, 
                     features = features, 
                     ngram.size = ngram.size)
    # if the dataset has already a form of list
  } else {
    # applying an appropriate function to a corpus:
    sample = lapply(tokenized.text, wrapper, 
                    features = features, 
                    ngram.size = ngram.size)
    class(sample) = "stylo.corpus"
  }
  
  
  
  
  return(sample)
}
