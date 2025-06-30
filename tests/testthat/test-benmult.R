library(testthat)
library(dplyr)

source("R/get_benmult_frs.R")
source("R/get_benmult_lookup.R")

test_cases <- read.csv("data/frs_benmult_test_cases_v5.csv")

test_that("get_benmult_frs matches known benmult", {
  tc <- test_cases %>%
    filter(dist_year > 0) %>%
    mutate(
      benmult_calc = get_benmult_frs(
        class,
        tier,
        early_retirement,
        dist_age,
        yos,
        dist_year
      )
    )

  expect_equal(tc$benmult_calc, tc$benmult, tolerance = 1e-8)
})

test_that("get_benmult_lookup matches known benmult", {
  tc <- test_cases %>%
    filter(dist_year > 0) %>%
    mutate(
      benmult_lookup = get_benmult_lookup(
        class,
        tier,
        early_retirement,
        dist_age,
        yos,
        dist_year
      )
    )

  expect_equal(tc$benmult_lookup, tc$benmult, tolerance = 1e-8)
})

test_that("get_benmult_frs and get_benmult_lookup agree", {
  tc <- test_cases %>%
    filter(dist_year > 0) %>%
    mutate(
      benmult_frs = get_benmult_frs(
        class,
        tier,
        early_retirement,
        dist_age,
        yos,
        dist_year
      ),
      benmult_lookup = get_benmult_lookup(
        class,
        tier,
        early_retirement,
        dist_age,
        yos,
        dist_year
      )
    )

  expect_equal(tc$benmult_frs, tc$benmult_lookup, tolerance = 1e-8)
})
