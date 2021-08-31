

test_that("small-int-to-words works", {
  expect_equal(
    small_int_to_words(603),
    "six hundred and three"
  )


  expect_equal(
    small_int_to_words(0),
    ""
  )

  expect_equal(
    small_int_to_words(12),
    "twelve"
  )

  expect_equal(
    small_int_to_words(123),
    "one hundred and twenty-three"
  )

  expect_equal(
    small_int_to_words(110),
    "one hundred and ten"
  )

  expect_equal(
    small_int_to_words(101),
    "one hundred and one"
  )

  expect_equal(
    small_int_to_words(100),
    "one hundred"
  )

  expect_equal(
    small_int_to_words(120),
    "one hundred and twenty"
  )

})
