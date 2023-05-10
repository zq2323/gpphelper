# https://stackoverflow.com/questions/74424135/r-encoding-and-decoding-data
asc <- function(x) { strtoi(charToRaw(x), 16L) }
chr <- function(n) { rawToChar(as.raw(n)) }
encrypt <- function(x, key, alphabet = ascii_chars) {
    s <- strsplit(x, "")
    sapply(s, function(y) {
        i <- match(y, alphabet)
        paste(key[i], collapse = "")
    })
}

ascii_printable <- 32:126
ascii_chars <- sapply(ascii_printable, chr)
encryptKey <- readRDS(system.file('encryptKey.rds', package = "gpphelper"))
encodeChar <- function(x){
    encrypt(x, encryptKey, ascii_chars)
}
decodeChar <- function(e){
    encrypt(e, ascii_chars, encryptKey)
}
