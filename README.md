# interactivegraphs: Interactive Graphs for Data Analysis for Social Science (DSS)

This repository contains interactive graphs that accompany the book [*Data Analysis for Social Science: A Friendly and Practical Introduction*](https://press.princeton.edu/books/paperback/9780691199436/data-analysis-for-social-science) by Elena Llaudet and Kosuke Imai, published by Princeton University Press.

## Installation

To access the interactive graphs, open RStudio and install the necessary packages by running the following code:

    install.packages("remotes")
    remotes::install_github("ellaudet/interactivegraphs")

## Running the Interactive Graphs

You can launch each interactive graph by running its corresponding R code in RStudio. Below are the commands to start each graph:

- **Random Treatment Assignment**
    
      shiny::runApp(appDir = system.file("shinyapps/random_treatment_assignment", package = "interactivegraphs"))
    
- **Random Sampling**
    
      shiny::runApp(appDir = system.file("shinyapps/random_sampling", package = "interactivegraphs"))
    
- **Means and Standard Deviations**
    
      shiny::runApp(appDir = system.file("shinyapps/mean_sd", package = "interactivegraphs"))
    
- **Correlation**
    
      shiny::runApp(appDir = system.file("shinyapps/correlation", package = "interactivegraphs"))
    
- **Linear Regression Model**
    
      shiny::runApp(appDir = system.file("shinyapps/linear_model", package = "interactivegraphs"))
    
- **Least Squares Method**
    
      shiny::runApp(appDir = system.file("shinyapps/least_squares_method", package = "interactivegraphs"))

To exit an interactive graph, you can close the browser window or press `Esc`.

## Feedback and Errors

Any errors in these graphs are my responsibility. If you encounter any issues or have suggestions for improvements, please contact me at [ellaudet@gmail.com](mailto:ellaudet@gmail.com). Your feedback is highly appreciated!

---

*I hope these interactive graphs are helpful to you and your students!* - Elena
