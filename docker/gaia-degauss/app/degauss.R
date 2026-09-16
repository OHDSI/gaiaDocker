library(plumber)

# configure and run endpoint
root <- pr("plumber.R")
root %>% pr_run(
  port=as.numeric(Sys.getenv(c("GAIA_DEGAUSS_API_PORT"))),
  host='0.0.0.0')