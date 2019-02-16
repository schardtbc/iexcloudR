context("test-iexcloud")

test_that("iexApiRequest works", {
  expect_that(iexApiRequest("/stock/AAPL/price"), is_a("numeric"))
})
