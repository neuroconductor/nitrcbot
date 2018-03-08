test_that("set_credentials", {
  testthat::expect_error(set_credentials(username = "", password = ""), "form_loginname and form_pw are not specified")
  testthat::expect_is(set_credentials(username = "user", password = "pass"), "list")
})

test_that("nitrc_login", {
  skip_on_cran()
  testthat::expect_is(nitrc_login(), "logical")
  username = Sys.getenv("TEST_NITRC_WEB_USER")
  password = Sys.getenv("TEST_NITRC_WEB_PASS")
  if(username == "") {username = "user"}
  if(password == "") {password = "pass"}
  set_credentials(username = username, password = password)
  testthat::expect_true(nitrc_login())
  set_credentials(username = "user", password = "pass")
})

test_that("check_user_session", {
  current_jsessionid = content(POST("https://www.nitrc.org/ir/data/JSESSION"))
  options("JSESSIONID" = current_jsessionid)
  testthat::expect_true(check_user_session())
  testthat::expect_is(check_user_session(), "logical")
})
