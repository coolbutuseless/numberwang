

test_that("num_to_words() works", {

  expect_equal(
    num_to_words(12),
    "twelve"
  )

  expect_equal(
    num_to_words(12.103),
    "twelve point one zero three"
  )

  expect_equal(
    num_to_words(-100),
    "negative one hundred"
  )


  expect_equal(
    num_to_words(0),
    "zero"
  )

  expect_equal(
    num_to_words(1e6 + 1),
    "one million and one"
  )

  expect_equal(
    num_to_words(2, decimals = 0),
    "two"
  )

})
