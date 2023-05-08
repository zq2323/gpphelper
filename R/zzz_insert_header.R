##########------------------

# Comment the code, since the |> and anonymous function \(x) not work when R version < 4.1

#' ##  help insert----
#' # one row below and jumps another row down
#' #' help insert
#' #'
#' #' A helper function to insert text
#' #' @param x An object to insert
#' #' @param start_row the start row of the insertion
#' #' @param start_indention The start position within the row
#' #' @param start_indention_margin A margin (i.e. spaces) that will be added
#' #'   at the target row before \code{x} is inserted.
#' #' @param end_row the row where the cursor should be after the insertion
#' #' @param end_indention The end position within the row
#' #' @importFrom rstudioapi insertText getActiveDocumentContext setCursorPosition
#' #' @keywords internal
#' help_insert <- function(x,
#'                         start_row = 1,
#'                         start_indention = Inf,
#'                         start_indention_margin = 0,
#'                         end_row = 2,
#'                         end_indention = Inf) {
#'     # get the row where the cursor is
#'     current_row <- getActiveDocumentContext()$selection[[1]]$range$start[1]
#'     # set the cursor to the very left of that row
#'     setCursorPosition(c(current_row, Inf))
#'     
#'     # insert end_row line breaks
#'     if(end_row > 0){
#'         insertText(paste(rep("\n", end_row), collapse = ""))
#'     }
#'     
#'     
#'     # insert the margin at the target row
#'     insertText(c(current_row  + start_row, start_indention),
#'                paste(rep(" ", start_indention_margin), collapse = ""))
#'     
#'     
#'     # insert the separator at the beginning of the new line, so \n gets
#'     # shifted down one
#'     # insertText(c(current_row  + start_row, start_indention), x)
#'     pos <- seq(length(x))
#'     x_rev <- rev(x)
#'     for (i in rev(pos)) {
#'         insertText(c(current_row  + start_row - i, start_indention), x_rev[i])
#'     }
#'     # move the cursor one line down
#'     setCursorPosition(c(current_row + end_row, end_indention), id = NULL)
#'     
#' }
#' #' reformat the line of template by keywords
#' #'
#' #' @param template the template read from .txt
#' #' @param row_item the keyword need to be updated
#' #' @param add_item the text need to be added in the end of row_item
#' #' @keywords internal
#' reformat_row <- function(template, row_item, add_item){
#'     
#'     origin_index <- which(grepl(row_item, template, ignore.case = TRUE))
#'     origin <- template[origin_index]
#'     new_row <- paste0(c(origin, rep(paste0("#", strrep(" ", nchar(origin)-1)), length(add_item)-1)), " ", add_item)
#'     vec_len <- length(template) + length(add_item) - 1
#'     update_template <- vector(mode = "character",length = vec_len)
#'     update_template <- c(template[1:(origin_index-1)], new_row, template[(origin_index + 1):length(template)])
#'     
#'     return(update_template)
#' }
#' 
#' #' insert template header before current program
#' #'
#' #' @param .header_config a file path to import the template header
#' #' @importFrom rstudioapi insertText getActiveDocumentContext setCursorPosition
#' #' @importFrom purrr map
#' #' @keywords internal
#' help_insert_header <- function(.header_config = options()$gpphelper$headerTemplate){
#'     if(!is.null(.header_config)){
#'         template_header <- readLines(options()$gpphelper$headerTemplate)
#'     }else{
#'         template_header <- readLines(system.file('template/header.txt', package = "gpphelper"))
#'     }
#'     
#'     #retrieve current package dependencies
#'     pkg <- renv::dependencies(path = rstudioapi::getActiveDocumentContext()$path)$Package
#'     pkg_version <- purrr::map(pkg, \(x) packageVersion(x) |> as.character())  |> purrr::flatten_chr()
#'     import_pkg <- paste0(pkg, " ", pkg_version)
#'     template_header <- template_header |>
#'         reformat_row("date", format(Sys.time(), "%Y-%m-%d")) |>
#'         reformat_row("Software", R.version$version.string) |>
#'         reformat_row("import", import_pkg)
#'     template_header <- c(template_header, " ")
#'     pos <- Map(c, 1:length(template_header), 1)
#'     
#'     # headers <- purrr::map(pos, \(x) rstudioapi::insertText(list(x), paste0(template_header[x[1]], "\n")))
#'     purrr::iwalk(pos, \(x, idx) rstudioapi::insertText(list(x), paste0(template_header[idx], "\n")))
#'     rstudioapi::setCursorPosition(c(length(template_header), Inf))
#'     
#'     invisible()
#' }
#' 
#' 
#' help_insert_comment <- function(.comment_config = options()$gpphelper$commentTemplate){
#'     if(!is.null(.comment_config)){
#'         template_comment <- readLines(options()$gpphelper$commentTemplate)
#'     }else{
#'         template_comment <- readLines(system.file('template/comment.txt', package = "gpphelper"))
#'     }
#'     template_comment <- gsub("date", format(Sys.time(), "%Y-%m-%d"), template_comment, ignore.case = TRUE)
#'     
#'     # get the row where the cursor is
#'     current_row <- getActiveDocumentContext()$selection[[1]]$range$start[1]
#'     pos <- Map(c, current_row:(current_row + length(template_comment) - 1), 1)
#'     
#'     purrr::iwalk(pos, \(x, idx) rstudioapi::insertText(list(x), paste0(template_comment[idx], "\n")))
#'     rstudioapi::setCursorPosition(c(current_row + 1, Inf))
#'     
#'     invisible()
#' }
