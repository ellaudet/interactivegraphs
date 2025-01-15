# interactivegraphs: Interactive Graphs for Data Analysis for Social Science (DSS)

This package contains interactive graphs for [*Data Analysis for Social Science: A Friendly and Practical Introduction*](https://press.princeton.edu/books/paperback/9780691199436/data-analysis-for-social-science) (DSS for short) by [Elena Llaudet](https://scholar.harvard.edu/ellaudet) and [Kosuke Imai](https://imai.fas.harvard.edu/) from Princeton University Press. 

To be able to access the graphs, open RStudio and run the following R code to install the necessary packages:

``` r
install.packages("remotes")
remotes::install_github("ellaudet/interactivegraphs")
```

Then, to start the graph that relates to *Random Treatment Assignment*, run the following piece of R code:

``` r
shiny::runApp(appDir = system.file("shinyapps/app1", package = "interactivegraphs"))
```
