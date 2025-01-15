# interactivegraphs: Interactive Graphs for Data Analysis for Social Science (DSS)

This package contains interactive graphs for [*Data Analysis for Social Science: A Friendly and Practical Introduction*](https://press.princeton.edu/books/paperback/9780691199436/data-analysis-for-social-science) (DSS for short) by Elena Llaudet and Kosuke Imai from Princeton University Press. 

To be able to access the graphs, open RStudio and run the following R code to install the necessary packages:

``` r
install.packages("remotes")
remotes::install_github("ellaudet/interactivegraphs")
```

Then, to start the graph that relates to *Random Treatment Assignment*, run the following piece of R code:

``` r
shiny::runApp(appDir = system.file("shinyapps/app1", package = "interactivegraphs"))
```

Any errors found in these interactive graphs are my own. If you find any, I would really appreciate it if you could let me know by sending me an email at [ellaudet@gmail.com](ellaudet@gmail.com). Thank you! 

*I hope these interactive graphs are helpful to you and/or your students!* - Elena
