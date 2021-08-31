


num_patterns <- c(
  hundred    = "\\w*? hundred",
  lion       = "thousand|\\w+llion",
  ten        = "ten|twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety",
  teen       = "eleven|twelve|thirteen|fourteen|fifteen|sixteen|seventeen|eighteen|nineteen",
  digit      = "zero|one|two|three|four|five|six|seven|eight|nine",
  point      = "point|\\.",
  negative   = "negative",
  other      = "[^\\s]+",
  whitespace = '\\s+'
)


hundreds_num <- c(
  `one hundred`   = 100,
  `two hundred`   = 200,
  `three hundred` = 300,
  `four hundred`  = 400,
  `five hundred`  = 500,
  `six hundred`   = 600,
  `seven hundred` = 700,
  `eight hundred` = 800,
  `nine hundred`  = 900
)

tens_num <- c(
  `ten`     = 10,
  `twenty`  = 20,
  `thirty`  = 30,
  `forty`   = 40,
  `fifty`   = 50,
  `sixty`   = 60,
  `seventy` = 70,
  `eighty`  = 80,
  `ninety`  = 90
)

digits_num <- c(
  `zero`  = 0,
  `one`   = 1,
  `two`   = 2,
  `three` = 3,
  `four`  = 4,
  `five`  = 5,
  `six`   = 6,
  `seven` = 7,
  `eight` = 8,
  `nine`  = 9
)

teens_num <- c(
  `eleven`    = 11,
  `twelve`    = 12,
  `thirteen`  = 13,
  `fourteen`  = 14,
  `fifteen`   = 15,
  `sixteen`   = 16,
  `seventeen` = 17,
  `eighteen`  = 18,
  `nineteen`  = 19
)


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a single character string into a numeric value
#'
#' @param words single character string
#'
#'
#' @examples
#' \dontrun{
#' words_to_num_single("twelve")
#' }
#'
#' @return numeric value
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
words_to_num_single <- function(words) {
  stopifnot(length(words) == 1)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Get rid of non number stuff
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  txt <- words
  txt <- gsub("-|,", " ", txt)
  txt <- gsub(" and", "", txt)
  txt <- gsub("\\s+", " ", txt)

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # split into tokens
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  tokens <- lex(txt, num_patterns)
  neg    <- 'negative' %in% names(tokens)
  tokens <- tokens[!names(tokens) %in% c('whitespace', 'negative')]

  if (any(names(tokens) == 'other')) {
    stop("Unknown symbols in text: ", deparse(unname(tokens[names(tokens) == 'other'])))
  }


  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Iterate over tokens, calculating the total numeric value
  #
  # * Assimulate values until we find one of the "-illion" markers.
  # * When a "-illion" marker is hit, work out its power-of-ten from its index
  #    in the 'big' vector, then multiple by the accumulator and add to total.
  #    Then reset the accumlator to zero
  #
  # This is going to have issues with floating-point accuracy, and would
  # possibly be more correctly done by constructing a character representation
  # of the number and then using "as.numeric()".
  #
  # But this is good enough for now.
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  total <- 0
  accum <- 0
  for (i in seq_along(tokens)) {
    type <- names(tokens)[i]
    val  <- tokens[[i]]
    # message(sprintf("[%i/%i] %s %s", accum, total, type, val))
    if (type == 'lion') {
      idx <- which(big == val)
      mult  <- 10 ^ (3 * (idx - 1))
      total <- total + accum * mult
      accum <- 0
    } else if (type == 'hundred') {
      accum <- accum + hundreds_num[[val]]
    } else if (type == 'ten') {
      accum <- accum + tens_num[[val]]
    } else if (type == 'teen') {
      accum <- accum + teens_num[[val]]
    } else if (type == 'digit') {
      accum <- accum + digits_num[[val]]
    } else if (type == 'point') {
      break
    }
  }
  total <- total + accum

  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Process any decimals after the decimal 'point'
  #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  if (length(tokens) > i) {
    # some decimal places to process
    N        <- length(tokens) - i
    decimals <- tokens[seq(i+1, length(tokens), 1)]
    vals     <- digits_num[decimals]
    frac     <- as.numeric(paste(vals, collapse="")) / 10^N
    total    <- total + frac
  }

  if (neg) {
    total <- -total
  }

  total
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Convert a character strings into numeric values
#'
#' @param words character vector
#'
#' @return numeric vector
#'
#' @examples
#' \dontrun{
#' words_to_num(c("twelve", "one hundred point three"))
#' }
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
words_to_num <- function(words) {
  unname(
    vapply(words, words_to_num_single, double(1))
  )
}



if (FALSE) {
  words <- "one hundred million, two thousand and forty two"
  words_to_num_single(words)
}







