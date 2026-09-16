#* Geocode the address
#* @param address The address
#* @serializer unboxedJSON
#* @get /geocode
function(address=""){
  if (address != "") {
    address <- dht::clean_address(address)
    res <- jsonlite::fromJSON(system2("ruby",
      args = c("/app/geocode.rb", shQuote(address)),
      stderr = FALSE, stdout = TRUE
    ))
  } else {
    res <- 'You must pass an address'
  }
  list(res)
}

#* say hello
#* @serializer text
#* @get /
function() {
  res <- paste0(
    "Hello, use this api as:\nhttp://localhost:",
    as.numeric(Sys.getenv(c("GAIA_DEGAUSS_API_PORT"))),
    "/geocode?address=URLeconcdedAddressString"
  )
}