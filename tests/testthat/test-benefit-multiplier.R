testthat::local_edition(3)
library(testthat)
library(dplyr)
library(readxl)

source(here::here("plan-name.R"))
source(here::here("functions-data.R"))

fname <- paste0(plan, "_inputs_raw.rds")
input_data_list <- readRDS(fs::path(xddir, fname))

# Source benefit-multiplier functions
source(here::here("plans", plan, "benefit-functions.R"))
source(here::here("plans", plan, "lookup-functions.R"))

# load lookup table and test data
# data <- get_data("benefit_rules", xdpath)

benefit_rules <- input_data_list[["benefit_rules"]]$data |>
  mutate(
    across(c(dist_age_min_ge:dist_year_max_lt, benmult), as.numeric),
    early_retirement = as.logical(early_retirement)
  )

test_cases <- input_data_list[["benefit_rules_test"]]$data |>
  mutate(
    across(dist_age:expected_benmult, as.numeric),
    early_retirement = as.logical(early_retirement)
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
