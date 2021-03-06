.colors <- list(
    default = c("firebrick1","orange3", "darkgoldenrod2", "grey90", 
                             RColorBrewer::brewer.pal(9, "YlGnBu")[c(4, 6, 7)]), 
    pvalue = c("firebrick1", "orange3", "grey90", "blue", "green4") %>% rev(),
    corr = RColorBrewer::brewer.pal(10, "RdYlBu")[-c(4, 7)],
    dem  = oce::colormap(name="gmt_globe")$col0[-(1:21)] %>% rev(),
    dem = c("#FFFFFF", "#FFFFFF", "#F2F2F2", "#E5E5E5", "#CCCCCC", "#C2B0B0", "#B79393", "#B27676", 
        "#A25959", "#996600", "#9C7107", "#9F7B0D", "#A28613", "#A49019", "#A89A1F", 
        "#D9A627", "#E6B858", "#F3CA89", "#FFDCB9", "#BBE492", "#33CC66", "#336600"),
    Tavg = RColorBrewer::brewer.pal(11, "RdYlBu") %>% rev(), #colormap(colormaps$temperature, 20), 
    # Prec = colormap::colormap("jet", 20) %>% rev(), 
    # Prec = RColorBrewer::brewer.pal(11, "RdBu"),
    Prec = RColorBrewer::brewer.pal(11, "RdYlBu"),
    Srad = RColorBrewer::brewer.pal(11, "RdBu") %>% rev(), 
    SOS = c("green4", "grey80", "firebrick1"), 
    # EOS = c("firebrick1", "orange3", "darkgoldenrod2", "grey80", RColorBrewer::brewer.pal(9, "Greens")[c(2, 4)+2]) # "yellow4"
    # EOS = RColorBrewer::brewer.pal(11, "BrBG")[1:6]
    EOS = c("green4", "grey80", "firebrick1") %>% rev(), 
    Blues = RColorBrewer::brewer.pal(9, "Blues")
    # EOS = c("firebrick1","orange3", "darkgoldenrod2", "grey80", "green2")
    # EOS = brewer.pal(11, 'BrBG')
)

a <- 4500; b <- 5500 # dem
a_EOS <- 265; b_EOS <- 275

.brks <- list(
    dem  = c(seq(3000, a-1, 250), seq(a, b-1, 125), seq(b, 7000, 250)),
    Tavg = c(seq(-10, 10, 1)), 
    Prec = c(seq(100, 400, 50),500, 600, 700, 800), 
    Srad = c(seq(150, 270, 10)), 
    SOS  = seq(120, 170, 5), 
    EOS  = c(seq(250, a_EOS-1, 5), seq(a_EOS, b_EOS-1, 5), seq(b_EOS, 290, 5))
) %>% map(~c(-Inf, ., Inf))

# bound of TP
xlim <- c(73.5049, 104.9725)
ylim <- c(25.99376, 40.12632)
