context("test-iexcloud")

test_that("iex works", {
  expect_that(iex("/stock/AAPL/price"), is_a("numeric"))
})
