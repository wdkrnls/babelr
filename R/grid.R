#' Include graphical objects in frames for convenient printing.
#' @param gobj Grob.
#' @param title Character(1).
#' @param border_col Character(1).
#' @param background_fill Character(1).
#' @param ... Extra strip parameters passed to rectGrob.
#' @return FramePic.
#' @importFrom grid grobTree rectGrob gpar textGrob unit
#' @importFrom gtable gtable_matrix
#' @export
frame_picture = function(gobj,
                         title = "Title",
                         border_col = "black",
                         background_fill = "grey",
                         ...) {
  strip = grobTree(rectGrob(gp = gpar(fill = background_fill, col = border_col, ...)),
                   textGrob(label = title))
  pict  = grobTree(gobj, rectGrob(gp = gpar(col = border_col, fill = NA)))
  p = gtable_matrix(name = "frame",
                    grobs = matrix(list(strip, pict), nrow = 2, ncol = 1),
                    widths = unit(1, units ="null"),
                    heights = unit(c(2, 1), units = c("lines", "null")))
  structure(list(grob = p), class = "framepic")
}


#' Print objects framepic to the graphics device.
#' @param x framepic object.
#' @return Nothing
#' @importFrom grid grid.draw grid.newpage
#' @export
print.framepic <- function(x) {
  grid::grid.newpage()
  grid::grid.draw(x$grob)
}

#' Combine multiple frames together
#' @param fs List-Of(Frames).
#' @param ... Extra frames which will get combined.
#' @param background_fill Character color of background.
#' @param foreground_color Character color of foreground text.
#' @importFrom gtable gtable_matrix
#' @importFrom grid nullGrob
#' @export
combine_frames = function(fs, ...,
                          background_fill = NULL,
                          foreground_color = NULL,
                          facet_layout = n2mfrow(n)) {
  fs = c(if(inherits(fs, "framepic")) list(fs) else fs, list(...))
  n = length(fs)
  if(length(background_fill) == 1) {
    background_fill <- rep(background_fill, n)
  }
  if(length(foreground_color) == 1) {
    foreground_color <- rep(foreground_color, n)
  }
  if(!is.null(background_fill)) {
    stopifnot(length(background_fill) == n)
  }
  if(!is.null(foreground_color)) {
    stopifnot(length(foreground_color) == n)
  }
  ly = facet_layout
  stopifnot(all(sapply(fs, function(f) inherits(f, "framepic"))))
  gs = lapply(fs, function(f) f$grob)
  m = prod(ly)
  nblank = m - n
  gs <- lapply(seq_along(gs), function(i) {
    g <- gs[[i]]
    nm = names(g$grobs[[1]]$children)
    ri = grep(pattern = "rect", nm)
    ti = grep(pattern = "text", nm)
    bg_fill =
      if(is.null(background_fill)) {
        g$grobs[[1]]$children[[ri]]$gp$fill
      } else {
        background_fill[i]
      }
    fg_col =
      if(is.null(foreground_color)) {
        g$grobs[[1]]$children[[ti]]$gp$col
      } else {
        foreground_color[i]
      }
    g$grobs[[1]]$children[[ri]]$gp$fill <- bg_fill
    g$grobs[[1]]$children[[ti]]$gp$col  <- fg_col
    g
  })
  gs <- c(gs, rep(list(nullGrob()), nblank))
  gt = gtable_matrix(name = "all",
                     grobs = matrix(gs,
                                    nrow = ly[1], ncol = ly[2]),
                     widths = unit(rep(1, ly[2]), units = "null"),
                     heights = unit(rep(1, ly[1]), units = "null"))
  structure(list(grob = gt), class = "framepic")
}
