#' reformat the line of template by keywords
#'
#' @param template the template read from .txt
#' @param row_item the keyword need to be updated
#' @param add_item the text need to be added in the end of row_item
#' @keywords internal
reformat_row <- function(template, row_item, add_item){

    if(!any(grepl(row_item, template, ignore.case = TRUE))){
        return(template)
    }
    origin_index <- which(grepl(row_item, template, ignore.case = TRUE))
    origin <- template[origin_index]
    new_row <- paste0(c(origin, rep(paste0("#", strrep(" ", nchar(origin)-1)), length(add_item)-1)), " ", add_item)
    vec_len <- length(template) + length(add_item) - 1
    update_template <- vector(mode = "character",length = vec_len)
    # updated, see below # update_template <- c(template[1:(origin_index-1)], new_row, template[(origin_index + 1):length(template)])
    if (origin_index == 1) {
      # when origin_index == 1, template[1:(origin_index-1)] should return nothing
      update_template <- c(new_row, template[(origin_index + 1):length(template)])
    } else if (origin_index == length(template)) {
      # when origin_index indicates the last element, template[(origin_index + 1):length(template)] should return nothing
      update_template <- c(template[1:(origin_index-1)], new_row)
    } else {
      update_template <- c(template[1:(origin_index-1)], new_row, template[(origin_index + 1):length(template)])
    }

    return(update_template)
}

#' insert template header before current program
#'
#' @param .header_config a file path to import the template header
#' @importFrom rstudioapi insertText getActiveDocumentContext setCursorPosition
#' @importFrom purrr map iwalk
#' @importFrom magrittr %>%
#' @keywords internal
help_insert_header <- function(opts = options()$gpphelper){

    auth <- auth_init()
    settings <- read_opts(opts = opts)
    template_header <- settings %>%
        dplyr::filter(author %in% auth) %>%
        dplyr::select(header) %>%
        dplyr::pull() %>%
        purrr::flatten_chr() %>%
        decodeChar()
    author <- decodeChar(auth)

    #retrieve current package dependencies
    pkg <- renv::dependencies(path = rstudioapi::getActiveDocumentContext()$path)$Package
    pkg_version <- purrr::map(pkg, function(x){ packageVersion(x) %>% as.character()})  %>% purrr::flatten_chr()
    import_pkg <- paste0(pkg, " ", pkg_version)
    template_header <- template_header %>%
        reformat_row("author", author) %>%
        reformat_row("program name", fs::path_file(rstudioapi::getActiveDocumentContext()$path)) %>%
        reformat_row(decodeChar("'y&]y97jM{`9j.MT7rf.xdx"), paste0(c(get0(decodeChar("iWTET1X{J{"), envir = .GlobalEnv, ifnotfound = NULL),
                                                       get0(decodeChar("iW'V[3V5E@"), envir = .GlobalEnv, ifnotfound = NULL),
                                                       get0(decodeChar("iW{/5@X"), envir = .GlobalEnv, ifnotfound = NULL)),
                                                       collapse = "/")) %>%
        reformat_row("# Date", format(Sys.time(), "%Y-%m-%d")) %>%
        reformat_row("Software", R.version$version.string) %>%
        reformat_row("import", import_pkg)
    template_header <- c(template_header, " ")
    pos <- Map(c, 1:length(template_header), 1)
    purrr::iwalk(pos, function(x, idx) rstudioapi::insertText(list(x), paste0(template_header[idx], "\n")))
    rstudioapi::setCursorPosition(c(length(template_header), Inf))

    invisible()
}

#' insert template comment before current line
#'
#' @param .comment_config a file path to import the template comment
#' @importFrom rstudioapi insertText getActiveDocumentContext setCursorPosition
#' @importFrom purrr iwalk map
#' @importFrom magrittr %>%
#' @keywords internal
help_insert_comment <- function(.comment_config = options()$gpphelper$commentTemplate){
    if(!is.null(.comment_config)){
        template_comment <- readLines(options()$gpphelper$commentTemplate)
    }else{
        template_comment <- readLines(system.file('template/comment.txt', package = "gpphelper"))
    }
    template_comment <- gsub("date", format(Sys.time(), "%Y-%m-%d"), template_comment, ignore.case = TRUE)

    # get the row where the cursor is
    current_row <- getActiveDocumentContext()$selection[[1]]$range$start[1]
    pos <- Map(c, current_row:(current_row + length(template_comment) - 1), 1)

    purrr::iwalk(pos, function(x, idx) rstudioapi::insertText(list(x), paste0(template_comment[idx], "\n")))
    rstudioapi::setCursorPosition(c(current_row + 1, Inf))

    invisible()
}
