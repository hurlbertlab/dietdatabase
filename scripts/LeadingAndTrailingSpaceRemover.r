# Function to remove unintended leading or trailing spaces from text fields

LeadingAndTrailingSpaceRemover = function(dietdatabase) {
  characterFields = which(sapply(dietdatabase, class) == "character")
  
  for (i in characterFields) {
    for (j in 1:nrow(dietdatabase)) {
      val = dietdatabase[j, i]
      #leading and trailing spaces
      if (substring(val, 1, 1) == " " & substring(val, nchar(val), nchar(val)) == " ") {
        dietdatabase[j, i] = substring(val, 2, nchar(val) - 1)
      #leading spaces
      } else if (substring(val, 1, 1) == " ") {
        dietdatabase[j, i] = substring(val, 2, nchar(val))
      #trailing spaces
      } else if (substring(val, nchar(val), nchar(val)) == " ") {
        dietdatabase[j, i] = substring(val, 1, nchar(val) - 1)
      }
    }
  }
  return(dietdatabase)
}
