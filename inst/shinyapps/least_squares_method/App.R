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

      /* Responsive adjustments */
      @media (max-width: 768px) {
        .col-sm-4 {
          margin-bottom: 20px;
        }
        h3 {
          font-size: 20px !important;
        }
        .framed-text {
          font-size: 14px !important;
        }
        .help-text {
          font-size: 14px !important;
        }
      }

      @media (max-width: 480px) {
        h3 {
          font-size: 18px !important;
        }
        .container-fluid {
          padding-left: 10px !important;
          padding-right: 10px !important;
        }
      }
    "))
  ),

  ## App Title
  h3("Interactive Graph: The Least Squares Method",
     style = "color: #ea3a44; text-align: center; margin-bottom: 0px;"),
  p("By Elena Llaudet, co-author of ",
    a("Data Analysis for Social Science", href = "https://bit.ly/dss_textbook", target = "_blank", style = "color: #797979; text-decoration: none; font-style: italic;"),
    " (DSS)", style = "text-align: center; color: #797979; margin-bottom: 10px; font-size: 18px;"),

  ## Framed Text
  div(class = "framed-text",
      style = "background-color: #f1f3f5;
              border-left: 4px solid #ea3a44;
              padding: 15px;
              margin-bottom: 10px;",
      p("To summarize the relationship between two variables, X and Y, we often use the least squares method.
      This method selects the line that minimizes the sum of squared residuals (SSR).
      Residuals—also known as errors—are the vertical distances between each data point and the line.
      The SSR captures the total magnitude of these errors by squaring them (which prevents negative and positive errors from canceling each other out) and summing them.
      The closer the line is to the data points, the smaller the errors and the SSR, and thus the better the line summarizes the relationship between X and Y.",
        style = "margin: 0; font-size: 16px; color: #333333;")
  ),

  ## Explanation
  helpText("Let's see how different lines fit the data to build an intuition about the least squares method:",
           class = "help-text",
           style = "font-size: 16px; color: #333333; margin-bottom: 10px"),

  ## Steps - All in one block for consistent spacing
  helpText(HTML("
    <ul style='line-height: 1.4;'>
      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 1:</b>
          The scatterplot below shows the relationship between X and Y.
          In theory, we could draw an infinite number of lines on this scatterplot,
          but some lines will summarize the relationship between X and Y better than others.
          Intuitively, we know that the line of best fit should be as close as possible to the data points,
          and thus have the smallest possible errors.
          Let's start by examining Line #1 (which is selected by default).
          Check the box to display both the line and its errors.
          This line does not fit the data well. It has a negative slope while X and Y clearly
          have a positive relationship, and as a result the errors are very large. In this case, SSR = 704.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 2:</b>
          Now, select Line #2 from the dropdown menu. This line fits the data better because it produces smaller errors (shorter vertical distances).
          Here, the SSR = 452. However, this is still not the best-fitting line, as the SSR can be reduced further.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 3:</b>
          Finally, select Line #3. The errors associated with Line #3 are the smallest among the three. Here, the SSR = 297, which is the lowest of all options.
          Line #3 is the one the least squares method would choose as the line of best fit, because it has the smallest SSR of all possible lines.
      </li>
    </ul>
  "), class = "help-text",
           style = "font-size: 16px; color: #333333; margin-bottom: 20px"),

  ## Sidebar Layout with Inputs and Outputs
  sidebarLayout(

    ## Sidebar Panel for Inputs
    sidebarPanel(

      ## Line Selection
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Choose the Line:</span>"),
      p("Select different lines to see how they fit the data.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      selectInput(
        inputId = "formula",
        label = NULL,
        choices = c("Line #1", "Line #2", "Line #3")
      ),

      ## Show Line and Errors Checkbox
      checkboxInput("show_line_errors", "Show Line and Errors", FALSE)
    ),

    ## Main Panel for Displaying Outputs
    mainPanel(

      ## Output: Graph (responsive height)
      plotOutput(outputId = "distPlot", height = "auto"),

      ## Text After Graph
      helpText("Note:
               A scatterplot enables us to visualize the relationship between two variables by
              plotting one variable against the other in two-dimensional space. Each dot represents an observation.
              The errors are the vertical distances between the dots and the line.",
               style = "font-size: 15px; color: #666; margin-top: 0px;")
    )
  )
)

## Define Server Logic Required to Draw the Graph
server = function(input, output, session) {

  # Pre-generate base data once for consistency (MOVED OUTSIDE OF REACTIVE)
  set.seed(1234)
  x <- rnorm(20, mean = 2, sd = 2)
  error <- rnorm(20, mean = 0, sd = 4)
  y <- -1 + 2 * x + error

  # Pre-calculate line parameters (MOVED OUTSIDE OF REACTIVE)
  line_params <- list(
    "Line #1" = list(intercept = 2, slope = -1, number = 1),
    "Line #2" = list(intercept = 2, slope = 0.5, number = 2),
    "Line #3" = list(intercept = -1, slope = 2, number = 3)
  )

  # Pre-calculate SSR for all lines (MOVED OUTSIDE OF REACTIVE)
  ssr_values <- sapply(line_params, function(params) {
    predicted_y <- params$intercept + params$slope * x
    residuals <- y - predicted_y
    sum(residuals^2)
  })

  # Reactive function to get current line parameters
  current_line <- reactive({
    line_params[[input$formula]]
  })

  # Reactive function to get current SSR
  current_ssr <- reactive({
    ssr_values[[input$formula]]
  })

  ## Graph
  output$distPlot <- renderPlot({

    # Get current line parameters
    params <- current_line()

    # Calculate predicted y values for selected line
    predicted_y <- params$intercept + params$slope * x

    # Responsive plot sizing
    plot_height <- session$clientData$output_distPlot_height
    plot_width <- session$clientData$output_distPlot_width

    # Adjust text size based on plot dimensions
    base_cex <- if(!is.null(plot_width) && plot_width < 500) 0.8 else 1
    title_cex <- if(!is.null(plot_width) && plot_width < 500) 1.1 else 1.3

    # Set plot parameters
    par(
      mfrow = c(1, 1),
      oma = c(1, 0.5, 1, 1) + 0.1,
      mar = c(1, 1, 3.5, 1) + 0.1,
      mgp = c(1, .5, 0),
      cex = base_cex,
      adj = 1,
      yaxs = "r",
      xaxs = "r",
      las = 1
    )

    # Create base plot
    plot(x, y,
         main = "",
         col = "#1f78b4",
         ylim = c(-11, 15),
         xlim = c(-4, 8),
         ylab = "",
         xlab = "",
         cex = base_cex,
         xaxt = "n",
         yaxt = "n",
         yaxs = "r",
         xaxs = "r",
         axes = FALSE,
         col.lab = "gray17",
         bty = "n",
         pch = 19
    )

    # Add errors first (so they go under the dots)
    if (input$show_line_errors == TRUE) {
      for (i in 1:length(predicted_y)) {
        lines(x = c(x[i], x[i]), y = c(predicted_y[i], y[i]), col = "gray40", lty = "dashed", lwd = 1)
      }
    }

    # Redraw the points on top of error lines
    if (input$show_line_errors == TRUE) {
      points(x, y, col = "#1f78b4", pch = 19, cex = base_cex)
    }

    # Add titles based on state
    if (input$show_line_errors == FALSE) {
      mtext("Scatterplot of X and Y",
            side = 3, line = 2, outer = FALSE, adj = 0.5, cex = title_cex, font = 2
      )
    }

    if (input$show_line_errors == TRUE) {
      abline(a = params$intercept, b = params$slope, col = "#1f78b4", lwd = 3)

      mtext(paste0("Scatterplot of X and Y with Line #", params$number),
            side = 3, line = 2, outer = FALSE, adj = 0.5, cex = title_cex, font = 2
      )

      # Add SSR as subtitle
      mtext(paste("SSR =", round(current_ssr(), 0)),
            side = 3, line = 0.6, outer = FALSE, adj = 0.5, cex = title_cex, font = 2, col = "#1f78b4"
      )
    }

    # Add axis labels
    mtext("Y", side = 2, line = 0.5, outer = FALSE, cex = base_cex, col.lab = "gray17", at = 15, adj = 1, col = "gray17")
    mtext("X", side = 1, line = 0.5, outer = FALSE, cex = base_cex, col.lab = "gray17", adj = 1, col = "gray17")

    box(col = "gray17")

  }, bg = "white",
  height = function() {
    # Dynamic height based on screen size
    session$clientData$output_distPlot_width * 0.75
  })
}

## Create Shiny App
shinyApp(ui = ui, server = server)
