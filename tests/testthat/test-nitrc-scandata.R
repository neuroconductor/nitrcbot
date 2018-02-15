test_that("nitrc_scandata",{
  set_credentials(username = "fakeuser", password = "fakepassword")

  testthat::expect_message(nitrc_scandata('42'),'Could not find project 42 in NITRC')
  testthat::expect_is(nitrc_scandata('ixi'),'data.frame')
  testthat::expect_null(nitrc_scandata('kin'))
  testthat::expect_message(nitrc_scandata(),"Aquiring scan data for all projects")
})
