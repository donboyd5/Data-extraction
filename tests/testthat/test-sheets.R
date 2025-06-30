# tests/test_sheets.R

testthat::local_edition(3)
library(testthat)

plan <- "frs"
xddir <- fs::path(here::here(), "plans", plan)
extracted_data <- paste0(plan, "_extracted_data.xlsm")
xdpath <- fs::path(xddir, extracted_data)

sheets <- readxl::excel_sheets(xdpath)
# note that deepseek prefers we not create sheets as a global variable

test_that("Workbook has required exact-match sheets", {
  required_sheets <- c("salary_growth", "retirees")
  cat("\n## Testing for existence of following required sheets:\n")
  cat(paste(required_sheets, collapse = ", "), "\n")

  expect_true(all(required_sheets %in% sheets))
})

test_that("Workbook has at least one headcount_ sheet", {
  headcount_sheets <- grep("^headcount_", sheets, value = TRUE)
  expect_gte(length(headcount_sheets), 1)
})

test_that("Workbook has at least one salary_ sheet (not counting salary_growth)", {
  salary_sheets <- grep(
    "^salary_",
    setdiff(sheets, "salary_growth"),
    value = TRUE
  )
  expect_gte(length(salary_sheets), 1)
})
