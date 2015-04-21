---
layout: post
title:  "A Tufte-style Jekyll blog powered by servr and knitr"
categories: [jekyll, rstats]
tags: [knitr, servr, httpuv, websocket]
---

<span class='newthought'>This post</span> demonstrates [my fork](http://github.com/cpsievert/knitr-jekyll) of Yihui's [knitr-jekyll](https://github.com/yihui/knitr-jekyll) which tweaks the default layout to resemble [tufte-jekyll](https://github.com/clayh53/tufte-jekyll). As Yihui mentions in his [knitr-jekyll blog post](http://yihui.name/knitr-jekyll/2014/09/jekyll-with-knitr.html) (which I _highly_ recommend reading), GitHub Pages does not support arbitrary Jekyll plugins, but I've managed to remove tufte-jekyll's dependency on custom plugins via custom [knitr output hooks](http://yihui.name/knitr/hooks/). Not only does this allow GitHub Pages to build and host this template automagically, but it also fixes [tufte-jekyll's problem with figure paths](https://github.com/clayh53/tufte-jekyll#which-brings-me-to-sorrow-and-shame). 

The rest of this post shows you how to use these custom hooks and some other useful things specific to this template (at some point, you might also want the [source for this post](https://raw.githubusercontent.com/cpsievert/knitr-jekyll/gh-pages/_source/2015-04-20-jekyll-tufte-servr.Rmd))



### Figures

By default, the `fig.width` [chunk option](http://yihui.name/knitr/options/) is equal to 7 inches. Assuming the zoom of your browser window is at 100%, that translates to about 3/4 of the textwidth.


{% highlight r %}
library(ggplot2)
p <- ggplot(diamonds, aes(carat)) 
p + geom_histogram()
{% endhighlight %}

<span class='marginnote'>Figure 1: A nice plot that is not quite wide enough. Note that this figure caption was created using the `fig.cap` chunk option</span><img class='fullwidth' src='/knitr-jekyll/figure/source/2015-04-20-jekyll-tufte-servr/skinny-1.png'/>

If we increase `fig.width` to a ridiculous number, say 20 inches, it will still be constrained to the text width, even by changing `fig.width` to 20 inches. 


{% highlight r %}
p + geom_histogram(aes(y = ..density..))
{% endhighlight %}

<span class='marginnote'>Figure 2: The `fig.height` for this chunk is same as Figure 1, but the `fig.width` is now 20. Since the width is constrained by the text width, the figure is shrunken quite a bit.</span><img class='fullwidth' src='/knitr-jekyll/figure/source/2015-04-20-jekyll-tufte-servr/wide-1.png'/>

By constraining the figure width, it will ensure that figure captions (set via `fig.cap`) appear correctly in the side margin. If you don't want to retrict the final figure width, set the `fig.fullwidth` chunk option equal to `TRUE`. In this case, the figure caption is placed in the side margin below the figure.


{% highlight r %}
p + geom_point(aes(y = price), alpha = 0.2) + 
  facet_wrap(~cut, nrow = 1, scales = "free_x") +
  geom_smooth(aes(y = price, fill = cut))
{% endhighlight %}

<div><img class='fullwidth' src='/knitr-jekyll/figure/source/2015-04-20-jekyll-tufte-servr/full-1.png'/></div><p><span class='marginnote'>Figure 3: Full width plot</span></p>

To place figures in the margin, set the `fig.margin` chunk option equal to `TRUE`.


{% highlight r %}
tmp <- tempfile()
user <- "http://user2014.stat.ucla.edu/images/useR-large.png"
download.file(user, tmp)
img <- png::readPNG(tmp)
plot(0:1, type = 'n', xlab = "", ylab = "")
lim <- par()
rasterImage(img, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
{% endhighlight %}

<span class='marginnote'><img class='fullwidth' src='/knitr-jekyll/figure/source/2015-04-20-jekyll-tufte-servr/margin-1.png'/>Figure 4: useR logo</span>

{% highlight r %}
unlink(tmp)
{% endhighlight %}

## Sizing terminal output
 
The default `R` terminal output width is 80, which is a bit too big for the styling of this blog, but a width of 55 works pretty well:


{% highlight r %}
options(width = 55, digits = 3)
(x <- rnorm(40))
{% endhighlight %}



{% highlight text %}
##  [1] -0.5526 -0.2789  0.0969  1.2977  2.0048  0.6793
##  [7] -0.3654  0.6100 -0.4588  0.2282  1.3401 -0.8668
## [13]  0.5047 -0.3934  0.0678  0.6107  0.3132 -0.4580
## [19] -0.7110 -0.2715 -1.2363 -1.0533  0.4212  1.2456
## [25]  0.5092 -0.0448  0.2914  1.4695  0.4842  0.7739
## [31]  0.1656 -0.1968 -0.8080 -0.1741  1.5958  0.8783
## [37]  1.0856  1.3591 -0.8850  0.8852
{% endhighlight %}

## Mathjax

If you want inline math rendering, put `$$ math $$` inline. For example, $$ \Gamma(\alpha) = (\alpha - 1)!$$. If you want it on it's own line, do something like:

{% highlight latex %}
$$
x = {-b \pm \sqrt{b^2-4ac} \over 2a}.
$$
{% endhighlight %}

which results in

$$
x = {-b \pm \sqrt{b^2-4ac} \over 2a}.
$$

## Margin notes

<span class='marginnote'> 
<img class="fullwidth" src="http://i.imgur.com/NCMxz5G.gif">
So excite.
</span>

Put stuff in the side margin using the `<span>` HTML tag with a class of 'marginnote':

{% highlight html %}
<span class='marginnote'> 
  Anything here will appear in side margin 
</span>
{% endhighlight %}

Another (less cute) example of margin notes is to add a table caption. In fact, the figure captions above are just margin notes.

<span class='marginnote'> 
Table 1: Output from a simple linear regression in tabular form.
</span>


|term        |   estimate| std.error| statistic|   p.value|
|:-----------|----------:|---------:|---------:|---------:|
|(Intercept) |  1.3571325| 0.2627456|  5.165195| 0.0000146|
|wt          | -0.2858443| 0.0782378| -3.653533| 0.0009798|


## Sidenotes

Similar to a 'marginnote' is a 'sidenote'<sup class='sidenote-number'> 1 </sup> which works like this

<span class='sidenote'>
  <sup class='sidenote-number'> 1 </sup> 
  Sidenotes are kind of like footnotes that appear in the side margin.
</span> 

{% highlight html %}
<sup class='sidenote-number'> 1 </sup>
<span class='sidenote'>
  <sup class='sidenote-number'> 1 </sup> 
  Sidenotes are kind of like footnotes that appear in the side margin.
</span> 
{% endhighlight %}

Unfortunately, this is a lot of HTML markup, but of course[^2], you can also do footnotes, so that might be a better option.

[^2]: I hate it when people say "of course" as though this is obvious everyone.

## Contact me

If you find any issues or want to help improve the implementation, [please let me know](https://github.com/cpsievert/knitr-jekyll/issues/new)!

## Session Information


{% highlight r %}
sessionInfo()
{% endhighlight %}



{% highlight text %}
## R version 3.1.3 (2015-03-09)
## Platform: x86_64-apple-darwin13.4.0 (64-bit)
## Running under: OS X 10.10.3 (Yosemite)
## 
## locale:
## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
## 
## attached base packages:
## [1] methods   stats     graphics  grDevices
## [5] utils     datasets  base     
## 
## other attached packages:
## [1] mgcv_1.8-4       nlme_3.1-120    
## [3] ggplot2_1.0.0.99
## 
## loaded via a namespace (and not attached):
##  [1] assertthat_0.1   broom_0.3.6     
##  [3] codetools_0.2-10 colorspace_1.2-4
##  [5] DBI_0.3.1        digest_0.6.8    
##  [7] dplyr_0.4.1      evaluate_0.5.5  
##  [9] formatR_1.0      grid_3.1.3      
## [11] gtable_0.1.2     knitr_1.9.3     
## [13] lattice_0.20-30  magrittr_1.5    
## [15] MASS_7.3-39      Matrix_1.1-5    
## [17] mnormt_1.5-1     munsell_0.4.2   
## [19] parallel_3.1.3   plyr_1.8.1      
## [21] proto_0.3-10     psych_1.5.1     
## [23] Rcpp_0.11.5      reshape2_1.4.1  
## [25] scales_0.2.4     stringr_0.6.2   
## [27] tidyr_0.2.0      tools_3.1.3
{% endhighlight %}
