test_that("crawl works", {
  # this crawls thousands of hits across several sequential paged requests,
  # which triggers rate limiting/blocking from dblp.org on CI runner IPs
  skip_on_ci()
  t1 <- dblp_crawl("chips", entity = "publications")$content
  expect_gt(nrow(t1), 1000)
})
