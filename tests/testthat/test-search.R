test_that("search works", {
  t1 <- dblp_search("European", entity = "venues")$content
  expect_gt(nrow(t1), 5)
})

test_that("search venues w zero hits works", {
  t1 <- dblp_search("venues", entity = "venues")$content
  expect_equal(nrow(t1), 0)
})

test_that("search authors w zero hits works", {
  t1 <- dblp_search("nooneinparticular", entity = "authors")$content
  expect_equal(nrow(t1), 0)
})
