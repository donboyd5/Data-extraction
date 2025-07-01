testthat::local_edition(3)
library(testthat)
library(dplyr)

source(here::here("plan_name.R"))

# Source benefit-multiplier functions
source(here::here("plans", plan, "benefit-functions.R"))
source(here::here("plans", plan, "lookup-functions.R"))

# load lookup table and test data
benefit_rules <- read_excel(xdpath, sheet = "benefit_rules", range = "D9:P98")
test_cases <- read_excel(
  xdpath,
  sheet = "benefit_rules_test",
  range = "D11:L61"
)

test_that("benmult_function matches expected benmult", {
  tc <- test_cases |>
    filter(dist_year > 0) |> # dist_year == 0 is oddball special_risk situation
    mutate(benmult_function = benmult_function(pick(everything())))

  expect_equal(tc$benmult_function, tc$expected_benmult, tolerance = 1e-8)
})

test_that("benmult_lookup matches expected benmult", {
  tc <- test_cases |>
    filter(dist_year > 0) |> # dist_year == 0 is oddball special_risk situation
    mutate(benmult_lookup = benmult_lookup(pick(everything()), benefit_rules))

  expect_equal(tc$benmult_lookup, tc$expected_benmult, tolerance = 1e-8)
})

test_that("benmult_function and benmult_lookup agree", {
  tc <- test_cases |>
    filter(dist_year > 0) |>
    mutate(
      benmult_function = benmult_function(pick(everything())),
      benmult_lookup = benmult_lookup(pick(everything()), benefit_rules)
    )

  expect_equal(tc$benmult_function, tc$benmult_lookup, tolerance = 1e-8)
})
