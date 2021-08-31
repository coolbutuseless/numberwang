


test_that("stress test", {

  set.seed(1)
  x <- c(
    1:1000,
    999:1222,
    sample(1e7, 1000)
  )

  w <- num_to_words(x)
  out <- words_to_num(w)

  expect_equal(x, out)

})
