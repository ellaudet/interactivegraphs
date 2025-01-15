# interactivegraphs: Interactive Graphs for Data Analysis for Social Science (DSS)

This package contains interactive graphs for [*Data Analysis for Social Science: A Friendly and Practical Introduction*](https://press.princeton.edu/books/paperback/9780691199436/data-analysis-for-social-science) (DSS for short) by Elena Llaudet and Kosuke Imai from Princeton University Press. 

To be able to access the graphs, open RStudio and run the following R code to install the necessary packages:

``` r
install.packages("remotes")
remotes::install_github("ellaudet/interactivegraphs")
```

Then, run the code related to the interactive graph you are interested in.

``` r
## Here is the code to start the graph that relates to *Random Treatment Assignment*:
shiny::runApp(appDir = system.file("shinyapps/random_treatment_assignment", package = "interactivegraphs"))
```



Once you are done playing with the interactive graph, to exit it either close the window or press esc.

``` r
shiny::runApp(appDir = system.file("shinyapps/mean_sd", package = "interactivegraphs"))
```

Any errors found in these interactive graphs are my own. If you find any, I would really appreciate it if you could let me know by sending me an email at [ellaudet@gmail.com](ellaudet@gmail.com). Thank you! 

*I hope these interactive graphs are helpful to you and/or your students!* - Elena
