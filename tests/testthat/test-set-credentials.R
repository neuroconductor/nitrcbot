test_that("set_credentials", {
  testthat::expect_error(set_credentials(username = "", password = ""), "form_loginname and form_pw are not specified")
  testthat::expect_is(set_credentials(username = "user", password = "pass"), "list")
})

test_that("nitrc_login", {
  testthat::expect_is(nitrc_login(), "logical")
})

test_that("check_user_session", {
  testthat::expect_is(check_user_session(), "logical")
})
