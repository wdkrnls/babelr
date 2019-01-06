#' Interface to babel command-line utility
babel <- function(..., cmd = "obabel") {
  dots = list(...)
  system2(command = cmd, args = dots)
}


#' Some documentation
#' @param filename Character file names of chemical structures.
#' @param cmd Character(1) obabel executable path.
#' @param output Character(1) directory to output files.
#' @param extra Character(1) arguments to format the SVG images.
#' @export
#' @importFrom grConvert convertPicture
#' @importFrom tools file_path_sans_ext
ob_render <- function(filename,
                      cmd = "obabel",
                      output = tempdir(),
                      extra = '-d -xC -xm -xj -xt -xd -xb none') {
  fh = unique(filename)
  out = output
  b = basename(fh)
  f = tools::file_path_sans_ext(b)
  p = file.path(out, paste0(f, ".svg"))
  o = file.path(out, paste0(f, "-grid.svg"))
  for(i in seq_along(fh)) {
    can = p[i]
    ofh = o[i]
    expr = paste(cmd, fh[i], "-O", can, extra)
    system(command = expr, intern = FALSE)
    if(file.exists(can)) {
      try(grConvert::convertPicture(file = can, outfile = ofh))
    }
  }
  l = list.files(path = out,
                 pattern = '*-grid.svg$',
                 full.names = TRUE)
  list(folder = out,
       created = l,
       requested = p)
}
