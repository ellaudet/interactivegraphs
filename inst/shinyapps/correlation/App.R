library(shiny)

## Define UI
ui = fluidPage(

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
  h3("Interactive Graph: Understanding the Correlation Coefficient",
     style = "color: #ea3a44; text-align: center; margin-bottom: 0px;"),
  p("By Elena Llaudet, co-author of ",
    a("Data Analysis for Social Science", href = "https://bit.ly/dss_textbook", target = "_blank", style = "color: #797979; text-decoration: none; font-style: italic;"),
    " (DSS)", style = "text-align: center; color: #797979; margin-bottom: 15px; font-size: 18px;"),

  ## Framed Text with Key Points
  div(style = "background-color: #f1f3f5;
            border-left: 4px solid #ea3a44;
            padding: 15px;
            margin-bottom: 15px;",
      p("The correlation coefficient (or correlation)
      captures the direction and strength of the linear association between two variables
      with a number that ranges from -1 to 1.",
        style = "margin: 0 0 10px 0; font-size: 16px; color: #333333;"),
      HTML("
      <ul style='margin: 0; padding-left: 20px; line-height: 1.4;'>
        <li style='margin-bottom: 8px; font-size: 16px; color: #333333;'>
          The sign reflects the direction: positive when the variables tend to move together (when the slope of the line of best fit
          is positive) and negative when the variables tend to move in opposite directions (when the slope of the line of best fit is negative).
        </li>
        <li style='margin-bottom: 0; font-size: 16px; color: #333333;'>
          The absolute value reflects the strength: it ranges from 0 (no linear association)
          to 1 (perfect linear association), increasing as dots get closer to the line of best fit.
        </li>
      </ul>
    ")),

  ## Explanation
  helpText("Let's explore how changing the direction and strength of the linear association affects the correlation coefficient:",
           style = "font-size: 16px; color: #333333; margin-bottom: 15px"),

  ## Steps
  helpText(HTML("
    <ul style='line-height: 1.4;'>
      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 1:</b>
          The graph below shows a scatterplot with a correlation of 1.
          The sign is positive because the slope of the line of best fit is positive (moves upwards from left to right),
          and the absolute value is 1 because all dots are exactly on the line.
          (Check the box below to show the line of best fit as a dashed red line.)
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 2:</b>
          Use the first drop-down menu to change the direction of the linear association.
          Notice that when the association goes from positive to negative,
          the line of best fit changes from sloping upwards to sloping downwards (from left to right) and
          the correlation coefficient goes from having a positive sign to having a negative sign.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 3:</b>
          Use the second drop-down menu to change the strength of the linear association.
          Weaker associations move dots farther from the line, decreasing the absolute value of the correlation.
          Stronger associations move dots closer to the line, increasing the absolute value of the correlation.
      </li>
    </ul>
  "), style = "font-size: 16px; color: #333333; margin-bottom: 20px"),

  ## Sidebar Layout with Inputs and Outputs
  sidebarLayout(

    ## Sidebar Panel for Inputs
    sidebarPanel(

      ## Direction
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Direction of Linear Association:</span>"),
      p("Select whether the variables tend to move in the same direction (positive) or in opposite directions (negative) and observe how that changes the slope of the line of best fit and the sign of the correlation coefficient.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      selectInput(
        inputId = "sign",
        label = NULL,
        choices = c("positive linear association", "negative linear association")
      ),

      ## Strength
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Strength of Linear Association:</span>"),
      p("Select the strength of the linear association and observe how that changes how tightly the dots cluster around the line of best fit and the absolute value of the correlation coefficient.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      selectInput(
        inputId = "strength",
        label = NULL,
        choices = c(
          "perfect linear association",
          "strong linear association",
          "weak to moderate linear association",
          "no linear association (approximately)"
        )
      ),

      ## Checkbox
      checkboxInput("line", "Show Line of Best Fit", FALSE)

    ),

    ## Main Panel for Displaying Outputs
    mainPanel(

      ## Output: Graph
      plotOutput(outputId = "distPlot", height = "400px"),

      ## Text After Graph
      helpText(HTML("Notes: A scatterplot enables us to visualize the relationship between two variables by
              plotting one variable against the other in two-dimensional space. Each dot represents an observation.
               The line of best fit is the line that best summarizes the data cloud.
              For illustration purposes, here we use <em>weak</em>, <em>moderate</em>, and <em>strong</em>,
               but note that what is considered a <em>strong</em> correlation in one field may be considered <em>weak</em> in another."),
               style = "font-size: 15px; color: #666; margin-top: 0px;")
    )
  ),
)

## Define Server Logic Required to Draw the Graph
server = function(input, output) {

  # Pre-generate base data once
  set.seed(1234)
  base_x <- rnorm(1000, mean = 50, sd = 10)

  # Create reactive values for computed data
  computed_data <- reactive({
    # Get sign multiplier
    sign_mult <- switch(input$sign,
                        "positive linear association" = 1,
                        "negative linear association" = -1)

    # Generate y values based on strength
    y_values <- switch(input$strength,
                       "no linear association (approximately)" = rnorm(1000, mean = 50, sd = 20),
                       "weak to moderate linear association" = base_x + rnorm(1000, mean = 50, sd = 16),
                       "strong linear association" = base_x + rnorm(1000, mean = 50, sd = 7),
                       "perfect linear association" = base_x)

    # Apply sign
    y_final <- sign_mult * y_values

    # Calculate correlation
    correlation <- cor(base_x, y_final)

    list(
      x = base_x,
      y = y_final,
      correlation = correlation
    )
  })

  ## Graph
  output$distPlot <- renderPlot({
    # Get computed data
    data <- computed_data()

    # Set up plot parameters once
    par(mfrow = c(1, 1), cex = 1.2, mar = c(1, 1, 3.5, 1))

    # Create the plot
    plot(data$x, data$y,
         col = "#1f78b4",
         ylab = "",
         xlab = "",
         cex = .6,
         xaxt = "n",
         yaxt = "n",
         yaxs = "r",
         xaxs = "r",
         axes = TRUE,
         col.lab = "#333333",
         bty = "n",
         pch = 19,
         col.main = "#333333",
         col.axis = "#333333")

    # Add regression line if requested
    if (input$line == TRUE) {
      abline(lm(data$y ~ data$x), col = "#ea3a44", lty = "dashed", lwd = 2)
    }

    # Add box and text
    box(col="gray17")
    mtext(paste("Correlation =", round(data$correlation, 2)),
          side = 3, line = .5, cex = 1.1, col = "#333333")
    mtext("Scatterplot", side=3, line = 1.5, cex=1.3, font=2)

  }, bg = "white")
}

## Create Shiny App
shinyApp(ui = ui, server = server)
