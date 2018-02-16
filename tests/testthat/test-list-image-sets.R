test_that("list_image_sets",{
  testthat::expect_is(list_image_sets(error = TRUE),"data.frame")
})
