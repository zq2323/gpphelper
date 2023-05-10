auth_init <- function(author_config = options()$gpphelper$author){
    if(Sys.getenv("user") != ""){
        # priority 1, take environment value
        auth <- encodeChar(Sys.getenv("user"))
        # message(glue::glue("Author name is {decodeChar(auth)}, from enviorment varibale [user]"))
    }else if(!is.null(author_config)){
        # priority 2, take options value
        auth <- encodeChar(author_config)
        # message(glue::glue("Author name is {decodeChar(auth)}, from options()$gpphelper$author"))
    }else{
        # priority 3, take options value
        auth <- encodeChar(Sys.info()["user"][1])
        # message(glue::glue("Author name is {decodeChar(auth)}, from system information"))
    }
    if(auth==""){
        auth <- encodeChar("Unknow")
        # message(glue::glue("Author name is Unknow, suggest to add the author name by options()$gpphelper$author or sys.setenv(user = XX.XX) "))
    }
    invisible(auth)
}


get_opts <- function(author = options()$gpphelper$author,
                     header_config = options()$gpphelper$headerTemplate,
                     comment_config = options()$gpphelper$comment){
    if(!is.null(header_config)){
        template_header <- readLines(options()$gpphelper$headerTemplate)
    }else{
        template_header <- readLines(system.file('template/header.txt', package = "gpphelper"))
    }

    if(!is.null(comment_config)){
        template_comment <- readLines(options()$gpphelper$commentTemplate)
    }else{
        template_comment <- readLines(system.file('template/comment.txt', package = "gpphelper"))
    }

    infos <- tibble::tibble(author = auth_init(), header = list(encodeChar(template_header)), comment = list(encodeChar(template_comment)))
    return(infos)
}

#' Save options()$gpphelper to system file
#'
#' @param opts options()$gpphelper
#' @importFrom dplyr filter bind_rows
#' @importFrom magrittr %>%
#' @keywords internal
add_opts <- function(opts = options()$gpphelper){

    if(!file.exists(file.path(system.file(package = "gpphelper"), "template/settings.rds"))){
        old_settings <- get_opts(author = "gpphelper", header_config = NULL, comment_config = NULL)
        saveRDS(old_settings, file.path(system.file(package = "gpphelper"), "template/settings.rds"))
    }
    old_settings <- readRDS(system.file('template/settings.rds', package = "gpphelper"))
    new_auth <- get_opts(author = opts$author,
                         header_config = opts$headerTemplate,
                         comment_config = opts$comment)

    auth <- auth_init()
    if(auth %in% old_settings$author){
        warning("you had set the Author name before")
    }
    new_settings <- old_settings %>%
        dplyr::filter(!author %in% auth) %>%
        dplyr::bind_rows(new_auth)
    saveRDS(new_settings, file.path(system.file(package = "gpphelper"), "template/settings.rds"))

    invisible()
}

read_opts <- function(opts = options()$gpphelper){

    auth <- auth_init()
    if(!file.exists(system.file('template/settings.rds', package = "gpphelper"))){
        add_opts(opts = opts)
    }
    settings <- readRDS(system.file('template/settings.rds', package = "gpphelper"))
    if(!auth %in% settings$author){
        add_opts(opts = opts)
    }
    settings <- readRDS(system.file('template/settings.rds', package = "gpphelper"))
    return(settings)
}
