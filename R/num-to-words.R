

ones <- list(
  `0` = NULL,
  `1` = 'one',
  `2` = 'two',
  `3` = 'three',
  `4` = 'four',
  `5` = 'five',
  `6` = 'six',
  `7` = 'seven',
  `8` = 'eight',
  `9` = 'nine'
)

frac_ones <- list(
  `0` = 'zero',
  `1` = 'one',
  `2` = 'two',
  `3` = 'three',
  `4` = 'four',
  `5` = 'five',
  `6` = 'six',
  `7` = 'seven',
  `8` = 'eight',
  `9` = 'nine'
)

teens <- list(
  `0` = 'ten',
  `1` = 'eleven',
  `2` = 'twelve',
  `3` = 'thirteen',
  `4` = 'fourteen',
  `5` = 'fifteen',
  `6` = 'sixteen',
  `7` = 'seventeen',
  `8` = 'eighteen',
  `9` = 'nineteen'
)

tens <- list(
  `0` = '',
  `1` = 'ten',
  `2` = 'twenty',
  `3` = 'thirty',
  `4` = 'forty',
  `5` = 'fifty',
  `6` = 'sixty',
  `7` = 'seventy',
  `8` = 'eighty',
  `9` = 'ninety'
)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# From: https://lcn2.github.io/mersenne-english-name/tenpower/tenpower.html
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
big <- c(
  "", "thousand", "million", "billion", "trillion", "quadrillion",
  "quintillion", "sextillion", "septillion", "octillion", "nonillion",
  "decillion", "undecillion", "duodecillion", "tredecillion", "quattuordecillion",
  "quindecillion", "sexdecillion", "septendecillion", "octadecillion",
  "novemdecillion", "vigintillion", "unvigintillion", "duovigintillion",
  "trevigintillion", "quattuorvigintillion", "quinvigintillion",
  "sexvigintillion", "septenvigintillion", "octavigintillion",
  "novemvigintillion", "trigintillion", "untrigintillion", "duotrigintillion",
  "tretrigintillion", "quattuortrigintillion", "quintrigintillion",
  "sextrigintillion", "septentrigintillion", "octatrigintillion",
  "novemtrigintillion", "quadragintillion", "unquadragintillion",
  "duoquadragintillion", "trequadragintillion", "quattuorquadragintillion",
  "quinquadragintillion", "sexquadragintillion", "septenquadragintillion",
  "octaquadragintillion", "novemquadragintillion", "quinquagintillion",
  "unquinquagintillion", "duoquinquagintillion", "trequinquagintillion",
  "quattuorquinquagintillion", "quinquinquagintillion", "sexquinquagintillion",
  "septenquinquagintillion", "octaquinquagintillion", "novemquinquagintillion",
  "sexagintillion", "unsexagintillion", "duosexagintillion", "tresexagintillion",
  "quattuorsexagintillion", "quinsexagintillion", "sexsexagintillion",
  "septensexagintillion", "octasexagintillion", "novemsexagintillion",
  "septuagintillion", "unseptuagintillion", "duoseptuagintillion",
  "treseptuagintillion", "quattuorseptuagintillion", "quinseptuagintillion",
  "sexseptuagintillion", "septenseptuagintillion", "octaseptuagintillion",
  "novemseptuagintillion", "octagintillion", "unoctogintillion",
  "duooctogintillion", "treoctogintillion", "quattuoroctogintillion",
  "quinoctogintillion", "sexoctogintillion", "septenoctogintillion",
  "octaoctogintillion", "novemoctogintillion", "nonagintillion",
  "unnonagintillion", "duononagintillion", "trenonagintillion",
  "quattuornonagintillion", "quinnonagintillion", "sexnonagintillion",
  "septennonagintillion", "octanonagintillion", "novemnonagintillion",
  "centillion", "cenuntillion", "cendotillion"
)



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' convert a number in range [0,999] to words
#'
#' @param num integer in range 0-999
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
small_int_to_words <- function(num) {

  num <- as.integer(num)
  stopifnot(num >= 0, num <= 999)

  x <- strsplit(as.character(num), "")[[1]]

  bits <- c()
  if (length(x) == 0 || all(x == '0')) {
    return("")
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # pad with "0" at front to make the logic a bit easier
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  while (length(x) != 3) {
    x <- c('0', x)
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Hundreds
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (x[1] != '0') {
    bits <- c(bits, ones[[x[1]]], "hundred")
    if (x[2] != '0' || x[3] != '0') {
      bits <- c(bits, 'and')
    }
  }

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # tens + ones
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (x[2] > "1") {
    this_tens <- tens[[x[2]]]
    this_ones <- ones[[x[3]]]
    if (x[3] != '0') {
      bits <- c(bits, paste(this_tens, this_ones, sep="-"))
    } else {
      bits <- c(bits, this_tens)
      bits <- c(bits, this_ones)
    }

  } else if (x[2] == '1') {
      bits <- c(bits, teens[[x[3]]])
  } else {
    bits <- c(bits, ones[[x[3]]])
  }


  paste(bits, collapse = " ")
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Create the cache of words for all numbers in range [0,999]
# also include these numbers with zero-prefix.
# This will be used for faster lookup
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
int_cache <- vapply(0:999, small_int_to_words, character(1))



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' convert a character vector of triplets into a word description
#'
#' @param triplets characcter vector of number triplets
#'
#' @examples
#' \dontrun{
#' triplets_to_words(c('123', '345'))
#' }
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
triplets_to_words <- function(triplets) {
  bigs      <- rev(big[seq.int(length(triplets))])
  trips     <- int_cache[as.integer(triplets) + 1L]

  keep_idx <- trips != ""
  bigs     <- bigs [keep_idx]
  trips    <- trips[keep_idx]

  N <- length(trips)

  last_trip <- trips[N]
  if (!grepl("hundred", last_trip) && N > 1) {
    first <- paste(trips[-N], bigs[-N], sep = ' ', collapse = ", ")
    last  <- paste("and", last_trip)
    paste(first, last)
  } else {
    paste(trips, bigs, sep = ' ', collapse = ", ")
  }
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a sequence of digits to a sequence of words
#'
#' This function trims traling zeros and prefixes the result with the word "point"
#'
#' @param digits single character with just digits e.g. "1056"
#'
#' @return single character string e.g. "point one zero five six"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
decimals_to_words <- function(digits) {
  # if (is.null(digits) || length(digits) == 0 || is.na(digits)) {
  #   return("")
  # }

  # Drop trailing zeros
  digits <- gsub("0+$", "", digits)
  if (digits == "") return("")

  digits <- strsplit(digits, "")[[1]]
  res <- paste(frac_ones[digits], collapse=" ")
  paste("point", res)
}



#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert numbers to words
#'
#' @param num numeric vector
#' @param decimals number of decimal places
#'
#' @return character vector
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
num_to_words <- function(num, decimals = 3) {

  char <- formatC(abs(num), big.mark=",", format = 'f', digits = decimals)

  int_frac <- do.call(rbind, strsplit(char, "\\."))

  all_triplets <- strsplit(int_frac[,1], ",")
  ints  <- vapply(all_triplets, triplets_to_words, character(1))

  if (decimals == 0) {
    fracs <- NULL
  } else {
    fracs <- vapply(int_frac[,2], decimals_to_words, character(1))
  }

  res <- trimws(paste(ints, fracs))
  res <- gsub("\\s+", " ", res)
  res <- ifelse(num < 0, paste("negative", res), res)
  res[res == ""] <- 'zero'
  res
}




if (FALSE) {
  num <- c(12, 100, 101, 110, 111, 120, 121, 129, exp(15))
  num_to_words(num, decimals = 4)
  decimals <- 3

  x <- 10^(sample(30))
  bench::mark(
    nombre::nom_ord(x),
    num_to_words(x, decimals = 0),
    check = FALSE
  )

}








