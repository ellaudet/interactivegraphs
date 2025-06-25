library(shiny)

## Define UI
ui = fluidPage(

  ## Match sidebar background to framed text
  tags$head(
    tags$style(HTML("
      .well {
        background-color: #f1f3f5 !important;
        border: none;
        box-shadow: none;
      }
    "))
  ),

  ## App Title
  h3("Interactive Graph: Mean and Standard Deviation",
     style = "color: #ea3a44; text-align: center; margin-bottom: 0px;"),
  p("By Elena Llaudet, co-author of ",
    a("Data Analysis for Social Science", href = "https://bit.ly/dss_textbook", target = "_blank", style = "color: #797979; text-decoration: none; font-style: italic;"),
    " (DSS)", style = "text-align: center; color: #797979; margin-bottom: 15px; font-size: 18px;"),

  ## Framed Text
  div(style = "background-color: #f1f3f5;
              border-left: 4px solid #ea3a44;
              padding: 15px;
              margin-bottom: 15px;",
      p("The mean determines the center of a distribution.
        The standard deviation determines its spread—roughly, the average distance from each observation to the mean.",
        style = "margin: 0; font-size: 16px; color: #333333;")),

  ## Explanation
  helpText("Let's see how changing the mean and standard deviation of a variable affects its distribution:",
           style = "font-size: 16px; color: #333333; margin-bottom: 15px"),

  ## Steps - All in one block for consistent spacing
  helpText(HTML("
    <ul style='line-height: 1.4;'>
      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 1:</b>
          The graph below shows the distribution of a normal random variable with mean 0 and standard deviation 1. (Note: We use a normal random variable as our illustration, but these concepts apply to others.)
          The mean centers the curve at zero; the standard deviation makes the observations be, on average, roughly 1 unit away from the mean.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 2:</b>
          Use the first slider to change the mean.
          Notice that this shifts the distribution left or right without changing its shape or spread.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 3:</b>
          Use the second slider to change the standard deviation.
          Notice that larger standard deviations create wider, flatter distributions, because the observations are, on average, further way from the mean.
          By contrast, smaller standard deviations create narrower, taller distributions, because the observations are, on average, closer to the mean.
          However, the center stays the same.
      </li>
    </ul>
  "), style = "font-size: 16px; color: #333333"),

  br(), ## to add blank space before graph

  ## Sidebar Layout with Inputs and Outputs
  sidebarLayout(

    ## Sidebar Panel for Inputs
    sidebarPanel(

      ## Mean
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Mean:</span>"),
      p("Move this slider to see how the mean changes the center of the distribution.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      sliderInput(
        inputId = "mean",
        label = NULL,
        min = -2,
        max = 2,
        value = 0
      ),

      br(),

      ## Standard Deviation
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Standard Deviation:</span>"),
      p("Move this slider to see how the standard deviation changes the spread of the distribution.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      sliderInput(
        inputId = "sd",
        label = NULL,
        min = 1,
        max = 3,
        value = 1
      )
    ),

    ## Main Panel for Displaying Outputs
    mainPanel(

      ## Output: Graph (aligned with top of slider)
      plotOutput(outputId = "distPlot", height = "400px"),

      ## Text After Graph
      helpText("Note: A density histogram shows the distribution of a variable through bins of different heights. The x-axis shows the range of values the variable takes, and the height of the bins indicates the relative proportion of the observations taking those values.",
               style = "font-size: 15px; color: #666; margin-top: 10px;")
    )
  ),
)

## Define Server Logic Required to Draw the Graph
server = function(input, output) {

  ## Graph
  output$distPlot <- renderPlot({

    # Set parameters
    x.bar <- input$mean
    sigma <- input$sd

    # Generate data
    set.seed(678)
    x <- rnorm(n = 1e6, mean = x.bar, sd = sigma)

    # Create plot with consistent styling
    par(mfrow = c(1, 1), cex = 1.2, mar = c(5, 4, 3, 2))

    hist(x,
         breaks = 100,
         freq = FALSE,
         col = "#1f78b4",
         ylim = c(0, 0.4),
         xlim = c(-10, 10),
         border = "white",
         main = "Distribution",
         xlab = "",
         ylab = "",
         col.main = "#333333",
         col.axis = "#333333",
         col.lab = "#333333",
         cex.main = 1.1)

    # Add "Density" at the top of y-axis
    mtext("density", side = 2, line = 2.5, at = 0.4 * 0.95, cex = 1.1, col = "#333333")

    # Add "Value" to the right of x-axis
    mtext("value", side = 1, line = 2.5, at = 10*0.95, cex = 1.1, col = "#333333")

    # Add parameter annotation
    mtext(paste("Mean =", x.bar, ", Standard Deviation =", sigma),
          side = 3, line = 0, cex = 1.1, col = "#333333")

  }, bg = "white")
}

## Create Shiny App
shinyApp(ui = ui, server = server)
