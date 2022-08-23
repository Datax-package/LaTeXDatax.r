require("pracma")

#' A function to print a single datum to file
#' @param file File handle of the file to print to
#' @param tag a tag to refer to in your document
#' @param value the value to connect to tag
#' @param unit the unit of value or an empty string
#' @param format numeric C-style format string
#' @return nothing
#'
print_datum <- function(file, tag, value, unit, format = "%.4g") {
    pracma::fprintf(
        "\\pgfkeyssetvalue{/datax/%s}{",
        tag,
        file = file,
        append = TRUE
        )
    if (unit == "") {
        if (is.character(value)) {
            pracma::fprintf("%s}\n", value, file = file, append = TRUE)
            return(NULL)
        }
        pracma::fprintf(
                        paste0("\\num{", format, "}}\n"),
                        value,
                        file = file,
                        append = TRUE
        )
        return(NULL)
    }
    pracma::fprintf(
                    paste0("\\qty{", format, "}{%s}}\n"),
                    value,
                    unit,
                    file = file,
                    append = TRUE)
}

#' A function to store a number of data to file
#' @param file file handle
#' @param ... tag-value pairs. The value can be a string, a number or
#'            a list of (value, unit) or (value, unit, format)
#' @return nothing
#' @export
#' @examples
#' datax(
#'       "data.tex",
#'       a=3, b="string", c=list(612.2,"nm"),
#'       d=c(3.14159265358979323846264338327950288419, "", "%.12f")
#'      )
#'
datax <- function(filename, ...) {
    h  <- file(filename, "w")
    pracma::fprintf(
        paste0(
            "%% Data file generated by LaTeXDatax.r\n",
            "%% Do not edit, may be overwritten!\n"
        ),
        file = h, append = FALSE
    )
    kwargs <- list(...)
    format <- kwargs[["format"]]
    if (is.null(format)) {
        format <- "%.4g"
    }
    for (tag in names(kwargs)) {
        if (nchar(tag) <= 0 || tag == "filename" || tag == "format") {
            next
        }
        item <- kwargs[[tag]]
        if (length(item) == 1) {
            print_datum(h, tag, item, "", format)
            next
        }
        if (length(item) == 2) {
            print_datum(h, tag, item[1], item[2], format)
            next
        }
        if (length(item) == 3) {
            print_datum(h, tag, item[1], item[2], item[3])
            next
        }
    }
    close(h)
}