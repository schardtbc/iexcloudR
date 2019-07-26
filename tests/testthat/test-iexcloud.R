context("test-iexcloud")

test_that("iex works", {
  expect_that(iex_api("/stock/AAPL/price"), is_a("iex_api"))
})
