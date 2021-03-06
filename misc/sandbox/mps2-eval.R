library(aqp)
library(mpspline2)
library(plyr)
library(lattice)


source('mps-functions.R')


# test data
ids <- LETTERS[1:6]

set.seed(10101)
x <- ldply(ids, random_profile, n=c(6, 7, 8), n_prop=1, method='LPP')
depths(x) <- id ~ top + bottom

# fake site data
site(x)$fake_site_attr <- 1:length(x)

# check source data
plot(x, color='p1')


# latest version, integrates most of the code from my previous 
# m <- mpspline(x, var_name = 'p1', d=c(0, 5, 15, 30, 60, 100, 200), out_style = 'spc')


# SPC -> MPS -> SPC
m <- mpsplineSPC(x, var='p1', d=c(0, 5, 15, 30, 60, 100, 200))

# check: OK
str(m)


# plot by group
par(mar=c(0, 0, 3, 1))
groupedProfilePlot(m, groups = 'id_group', color='p1', max.depth=175, group.name.offset = -10, name='', divide.hz=FALSE)

groupedProfilePlot(m, groups = 'method_group', color='p1', max.depth=175, group.name.offset = -10, name='', divide.hz=FALSE)


# compare depth-functions by method, no aggregation
xyplot(cbind(top, bottom) ~ p1 | factor(id_group), id=m$id, groups=factor(method_group), 
       data=as(m, 'data.frame'),
       par.settings=list(superpose.line=list(lwd=2, col=c('RoyalBlue', 'darkgreen', 'firebrick'))),
       auto.key=list(columns=3, lines=TRUE, points=FALSE),
       strip=strip.custom(bg=grey(0.85)),
       ylim=c(175, -5), as.table=TRUE, panel=panel.depth_function
       )



# aggregate by method_group
a <- slab(m, fm = method_group ~ p1)

xyplot(top ~ p.q50, groups=factor(method_group), data=a, ylab='Depth', asp=1.5,
       lower=a$p.q25, upper=a$p.q75, ylim=c(200,-5),
       xlab='median bounded by 25th and 75th percentiles',
       sync.colors=TRUE, alpha=0.25,
       par.settings=list(superpose.line=list(lwd=2, col=c('RoyalBlue', 'darkgreen', 'firebrick'))),
       auto.key=list(columns=3, lines=TRUE, points=FALSE),
       panel=panel.depth_function, 
       prepanel=prepanel.depth_function,
       cf=a$contributing_fraction,
       scales=list(x=list(alternating=1))
)

xyplot(top ~ p.q50, groups=factor(method_group), data=a, ylab='Depth', asp=1.5,
       ylim=c(200,-5),
       xlab='median bounded by 25th and 75th percentiles',
       par.settings=list(superpose.line=list(lwd=2, col=c('RoyalBlue', 'darkgreen', 'firebrick'))),
       auto.key=list(columns=3, lines=TRUE, points=FALSE),
       panel=panel.depth_function, 
       prepanel=prepanel.depth_function,
       scales=list(x=list(alternating=1))
)

xyplot(top ~ p.q50 | factor(method_group), data=a, ylab='Depth', asp=1.5,
       lower=a$p.q25, upper=a$p.q75, ylim=c(200,-5),
       xlab='median bounded by 25th and 75th percentiles',
       sync.colors=TRUE, alpha=0.5,
       strip=strip.custom(bg=grey(0.85)),
       par.settings=list(superpose.line=list(lwd=2, col=c('RoyalBlue', 'firebrick'))),
       panel=panel.depth_function, 
       prepanel=prepanel.depth_function,
       cf=a$contributing_fraction,
       scales=list(x=list(alternating=1))
)

