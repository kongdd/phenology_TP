source("test/main_pkgs.R")

load(file_plsr) 
load(file_trend)

load("data/00basement_TP.rda") 
load(file_pheno_010)
load(file_preseason)
ngrid = length(gridclip2_10)

melt_list2 <- function(res){
  melt_tree(res, c("type_trend", "type_source")) %>% 
    melt(c("type_trend", "type_source", "I"))  
}

{
  lst_trend = list(MK = l_mk.main, LM = l_lm.main)
  type_sources = names(lst_trend[[1]])
  
  years = c(16, 16, 14)
  # update attributable change
  res <- foreach(l_trend = lst_trend) %do% {
      foreach(obj = lst_plsr[type_sources], trend = l_trend, nyear = years) %do% {
          ans = attribute_change(obj, trend, nyear)
          x <- ans[, -1]
          x[abs(x) > 50] = 50
          cbind(ans[, 1], x)
      }
  }
  res.RC = map_depth(res, 2, function(d){
    d = d[, -(1:2)] %>% abs()
    sum = as.matrix(d) %>% rowSums2()
    perc = d/sum*100  
    cbind(I = 1:ngrid, perc)
  })
  # dorm
  res.dorm = map_depth(res, 2, function(d){
    d = d[, -(1:2)] %>% abs()
    dorm = apply(d, 1, which.max) %>% map_int(first)
    # browser()
    cbind(I = 1:ngrid, dorm) %>% as.data.table()
  })
  
  varnames = colnames(res[[1]][[1]])[-(1:2)]
  df    <- melt_list2(res)
  df.RC <- melt_list2(res.RC)
  df.dorm <- melt_tree(res.dorm, c("type_trend", "type_source"))
  df.dorm$dorm %<>% factor(labels = varnames)

  ## df.RC sos and mete
  df.RC2 = list(Mete = df.RC[variable != "SOS", .(value = sum(value, na.rm = TRUE)), .(type_trend, type_source, I)],
    SOS = df.RC[variable == "SOS", .(value = sum(value, na.rm = TRUE)), .(type_trend, type_source, I)]) %>% 
    melt_list("variable")
}

## 1. Figure4 (Attributable change, days) --------------------------------------
Figure4 = TRUE
if (Figure4){
  # pvalue mask
  df.mask <- map_depth(lst_trend, 2, ~cbind(I = 1:ngrid, .x$pvalue)) %>% 
    melt_list2() %>% 
    .[, mask := value <= 0.05]
  df      <- melt_list2(res)
  
  ymax = 10
  brks = c(0.5, 1, 2, 5, 10, Inf) %>% c(-rev(.), 0, .)
  pars = list(title = list(x=77, y=39, cex=1.5), 
              hist = list(origin.x=77, origin.y=28, A=12, by = 0.5, box.width = 0.48, ylab.offset = 3, 
                          tick = seq(0, 0.3, 0.1)))
  stat = list(show = TRUE, name="Days", loc = c(84.5, 25.7), digit = 1, include.sd = TRUE, FUN = weightedMean)
  SpatialPixel = gridclip2_10[, 1]
  labels = c(
    expression(bold("GIMMS"[3*g] * " (2000-2015)")), 
    expression(bold("MODIS (2000-2015)")), 
    expression(bold("SPOT (2000-2013)")))
  # df$type_source %<>% factor(labels = labels)
  p <- levelplot2(value ~ s1 + s2 | type_source + variable, 
                  df[type_trend == "MK" & variable == "EOS"], SpatialPixel, 
                  df.mask[type_trend == "MK" & variable == "EOS"],
                  sp.layout = sp_layout,
                  ylim = c(25.5, 40.5),
                  xlim = c(73.2, 104.98),
                  colors = RColorBrewer::brewer.pal(11, "RdYlBu"),
                  stat = stat, pars = pars,
                  brks = brks,
                  # strip = TRUE,
                  density = 0.5,
                  par.shade = list(lwd = 0.5), 
                  border = "white", border.lwd = 0.01,
                  legend.space = "bottom", 
                  legend.num2factor = TRUE, 
                  par.settings2 = list(strip.background = list(alpha = 0)),
                  par.strip.text = list(cex = 1.5, font = 2, fontfamily = "Times", lineheight = 2),
                  # par.settings = opt_trellis_strip,
                  interpolate = FALSE,
                  aspect = .6) 
  p %<>% useOuterStrips(strip = strip.custom(factor.levels = labels), strip.lines = 1.1)
  # write_fig(p, "Figure4_attributable_changes_all_factors.pdf", 10, 12.5)
  write_fig(p, "Figure4_EOS_changes.pdf", 10, 3) # clear and small file size

  cols = RColorBrewer::brewer.pal(11, "RdYlBu")
  # cols = rcolors::get_color("MPL_RdYlGn", 9)
  p <- levelplot2(value ~ s1 + s2 | type_source + variable, 
                  df[type_trend == "MK" & variable != "EOS"], SpatialPixel, 
                  df.mask[type_trend == "MK" & variable != "EOS"],
                  sp.layout = sp_layout,
                  ylim = c(25.5, 40.5),
                  xlim = c(73.2, 104.98),
                  colors = cols,
                  stat = stat, pars = pars,
                  brks = brks,
                  # strip = TRUE,
                  density = 0.5,
                  par.shade = list(lwd = 0.5), 
                  border = "white", border.lwd = 0.01,
                  legend.space = "bottom", 
                  legend.num2factor = TRUE, 
                  par.settings2 = list(strip.background = list(alpha = 0)),
                  par.strip.text = list(cex = 1.5, font = 2, fontfamily = "Times", lineheight = 2),
                  # par.settings = opt_trellis_strip,
                  interpolate = FALSE,
                  aspect = .6) 
  p %<>% useOuterStrips(strip = strip.custom(factor.levels = labels), strip.lines = 1.1)
  # write_fig(p, "FigureS4_attributable_changes_all_factors.pdf", 10, 12.5)
  write_fig(p, "Figure5_attributable_changes_all_factors.pdf", 10, 10.5) # clear and small file size
  # p <- spplot(gridclip2_10, 1, col = "red", border = "white", border.lwd = 0.01)
}
