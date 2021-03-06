
# useful for debugging plotSPC
explainPlotSPC <- function(x, ...) {
  plot(x, id.style='side', ...)
  box()
  
  # get last plot parameters
  lsp <- get('last_spc_plot', envir=aqp.env)
  
  # get max depth by profile
  max.depths <- profileApply(x, max)
  
  # re-order max depths
  max.depths <- max.depths[lsp$plot.order]
  
  # apply y-offset and scaling factor
  scaled.max.depths <- lsp$y.offset + (lsp$scaling.factor * max.depths)
  scaled.depth.axis <- lsp$y.offset + (lsp$scaling.factor * pretty(1:max(x)))
  
  # suitable location for y-space annotation
  y.space.x <- 2.5
  
  # suitable location for x-space annotation
  # index of last profile + some
  x.space.x <- lsp$n + (length(x) * 0.05)
  # 95% of total scaled depths
  x.space.y <- max(scaled.max.depths) * 0.95
  
  # original profile index text y-coordinate
  # roughly 10% of the max(transformed depths)
  original.profile.idx.y <- lsp$y.offset + (-max(scaled.max.depths) * 0.1)
  
  
  # inspect plotting area, very simple to overlay graphical elements
  segments(x0 = 1:length(x), x1=1:length(x), y0=lsp$max.depth, y1=scaled.max.depths, lty=3, lwd=2, col='darkgreen')
  
  # profiles are centered at integers, from 1 to length(obj)
  axis(1, line=0.25, at=1:lsp$n, cex.axis=0.75, font=4, col='darkgreen', col.axis='darkgreen', lwd=2)
  mtext('canvas x-coordinate', side=1, line=2.25, font=4, col='darkgreen')
  
  # y-axis is based on profile depths
  axis(2, line=0.25, at=scaled.depth.axis, cex.axis=0.75, font=4, las=1, col='blue', col.axis='blue', lwd=2)
  mtext('canvas y-coordinate', side=2, line=2.25, font=4, col='blue')
  
  # show extra y-space
  arrows(x0=y.space.x, x1=y.space.x, y0=0, y1=-lsp$extra_y_space, length = 0.08, code = 3, col='orange', lwd=1)
  text(x=y.space.x, y=-lsp$extra_y_space/2, labels = 'extra y-space', cex=0.65, pos=2, font=3, col='orange')
  text(x=y.space.x, y=-lsp$extra_y_space/2, labels = lsp$extra_y_space, cex=0.85, pos=4, font=2, col='orange')
  
  # show extra x-space
  arrows(x0=lsp$n, x1=lsp$n + lsp$extra_x_space, y0=x.space.y, y1=x.space.y, length = 0.08, code = 3, col='orange', lwd=1)
  text(x=x.space.x, y=x.space.y, labels = 'extra x-space', cex=0.65, pos=3, font=3, col='orange')
  text(x=x.space.x, y=x.space.y, labels = lsp$extra_x_space, cex=0.85, pos=1, font=2, col='orange')
  
  # plotting order
  text(x=1:length(x), y=original.profile.idx.y, labels=lsp$plot.order, col='darkred', font=4, cex=0.75)
  mtext('original profile index', side=3, line=0, font=4, col='darkred')
  
  invisible(lsp)
}
