test_that("crawl works", {
  t1 <- dblp_crawl("chips", entity = "publications")$content
  expect_gt(nrow(t1), 1000)
})
