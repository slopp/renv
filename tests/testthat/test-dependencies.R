
context("Dependencies")

test_that("usages of library, etc. are properly handled", {

  deps <- dependencies("resources/code.R")
  pkgs <- deps$Package

  expect_equal(pkgs, tolower(pkgs))

  l <- pkgs[nchar(pkgs) == 1]
  expect_equal(sort(l), letters[seq_along(l)])

})

test_that("parse errors are okay in .Rmd documents", {
  expect_warning(deps <- dependencies("resources/chunk-errors.Rmd"))
  pkgs <- deps$Package
  expect_setequal(pkgs, c("rmarkdown", "dplyr"))
})

test_that("inline chunks are parsed for dependencies", {
  deps <- dependencies("resources/inline-chunks.Rmd")
  pkgs <- deps$Package
  expect_setequal(pkgs, c("rmarkdown", "inline", "multiple", "separate"))
})

test_that("usages of S4 tools are discovered", {

  file <- renv_test_code({setClass("ClassSet")})
  deps <- dependencies(file)
  expect_true(deps$Package == "methods")

})

test_that("the package name is validated when inferring dependencies", {

  file <- renv_test_code({SomePackage::setClass("ClassSet")})
  deps <- dependencies(file)
  expect_true("SomePackage" %in% deps$Package)
  expect_false("methods" %in% deps$Package)

})
