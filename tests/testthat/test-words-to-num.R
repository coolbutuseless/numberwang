
test_that("words-to-num works", {

  expect_equal(
    words_to_num("three point one four one five nine"),
    3.14159
  )



  expect_equal(
    words_to_num("negative three point one four one five nine"),
    -3.14159
  )



  expect_error(
    words_to_num("three point won"),
    "Unknown symbols"
  )


})
