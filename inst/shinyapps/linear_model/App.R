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
  h3("Interactive Graph: Intercept and Slope of a Line",
     style = "color: #ea3a44; text-align: center; margin-bottom: 0px;"),
  p("By Elena Llaudet, co-author of ",
    a("Data Analysis for Social Science", href = "https://bit.ly/dss_textbook", target = "_blank", style = "color: #797979; text-decoration: none; font-style: italic;"),
    " (DSS)", style = "text-align: center; color: #797979; margin-bottom: 15px; font-size: 18px;"),

  ## Framed Text
  div(style = "background-color: #f1f3f5;
           border-left: 4px solid #ea3a44;
           padding: 15px;
           margin-bottom: 15px;",

      p("We can define a line as Y = α + βX, where:",
        style = "margin: 0 0 10px 0; font-size: 16px; color: #333333;"),

      HTML("<ul style='margin: 0; padding-left: 20px; line-height: 1.4;'>
      <li style='margin-bottom: 8px; font-size: 16px; color: #333333;'>
        α (alpha) is the intercept: the value of Y when X=0, which determines the vertical location of the line. </li>
      <li style='margin-bottom: 0; font-size: 16px; color: #333333;'>
        β (beta) is the slope: the change in Y divided by the change in X (rise over run) between two points on the line, which determines the steepness of the line. It can be interpreted as the change in Y associated with a one-unit increase in X.</li>
    </ul> ")),

  ## Explanation
  helpText("Let's see how changing the intercept and slope affects the line:",
           style = "font-size: 16px; color: #333333; margin-bottom: 15px"),

  ## Steps
  helpText(HTML("
  <ul style='line-height: 1.4'>
    <li style='margin-bottom: 10px'>
      <b style='color: #ea3a44;'>STEP 1:</b>
      The graph below shows a line with an intercept of 1 and a slope of 2. The line is therefore: Y = 1 + 2X.
      <ul style='margin-left: 0; padding-left: 20px; list-style-position: outside; line-height: 1.4'>
        <li style='margin-bottom: 5px; margin-top:5px;'>
          To verify the intercept, find 0 on the x-axis, move up to the line, and find the corresponding Y-value.
          The point is (0,1), confirming that the intercept is 1.
          (Check the first box to show this point as a blue circle.)
          IMPORTANT: The intercept is NOT always where the line crosses the y-axis shown on a scatterplot, because that y-axis might not be drawn exactly at X=0 (as is the case here).
        </li>

        <li style='margin-bottom: 10px;'>
          To verify the slope, choose any two points on the line and compute rise over run.
          For example, use (0,1) and the point where X = 2, which is (2,5).
          (Check the second box to show this point as a blue triangle.)
          The rise (change in Y) is 5-1 = 4 and the run (change in X) is 2-0 = 2, so rise over run = 4/2 = 2.
          Every one-unit increase in X is associated with an increase in Y of 2 units.
        </li>
      </ul>
    </li>

    <li style='margin-bottom: 10px;'>
      <b style='color: #ea3a44;'>STEP 2:</b>
      Move the first slider below to change the intercept.
      Notice that changing the intercept shifts the entire line vertically up or down but does not change its steepness.
      For example, changing the intercept from 1 to -1 shifts the entire line down by 2 units:
      the point at X=0 moves from (0,1) to (0,-1), and the point at X=2 moves from (2,5) to (2,3).
      Neither rise nor run have changed. The rise is 3-(-1) = 4 and the run is 2-0 = 2, so rise over run remains the same.

    </li>

    <li style='margin-bottom: 10px;'>
      <b style='color: #ea3a44;'>STEP 3:</b>
      Move the second slider to change the slope.
      Notice that the slope affects the steepness of the line but does not affect its vertical position.
      <ul style='margin-left: 0; padding-left: 20px; list-style-position: outside; line-height: 1.4'>
        <li style='margin-bottom: 5px; margin-top:5px;'>
          For example, if we keep the intercept at 1 but decrease the slope from 2 to 1, the line becomes less steep.
          The point at X=0 stays at (0,1)&mdash;the intercept is not affected&mdash;but the point at X=2 drops to (2,3).
          The new rise is 3-1 = 2 and the run is still 2, so the new slope is 2/2 = 1.
          Now, every one-unit increase in X is associated with an increase in Y of 1 unit.
        </li>

        <li style='margin-bottom: 10px'>
          Now, let's try a negative slope.
          As the slope changes from positive to negative, the line will go from moving upwards to moving downwards (from left to right),
          thus the direction of the steepness reverses.
          For example, if we keep the intercept at 1 but change the slope to -2,
          the point at X=0 stays at (0,1), as expected, but the point at X=2 drops to (2,-3).
          The new rise is -3-1 = -4 and the run continues to be 2, so the new slope is -4/2 = -2.
          Now, every one-unit increase in X is associated with a <em>decrease</em> in Y of 2 units.
        </li>
      </ul>
    </li>
  </ul>
"), style = "font-size: 16px; color: #333333; margin-bottom: 20px"),

  ## Sidebar Layout with Inputs and Outputs
  sidebarLayout(

    ## Sidebar Panel for Inputs
    sidebarPanel(

      ## Checkboxes
      div(style = "margin-bottom: 15px",
          checkboxInput("red_dot", HTML("Show Point at X=0 (Blue Circle)"), FALSE)),

      div(style = "margin-bottom: 20px",
          checkboxInput("black_dot", HTML("Show Point at X=2 (Blue Triangle)"), FALSE)),

      ## Intercept
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Intercept:</span>"),
      p("Move this slider to see how the intercept changes the vertical location of the line.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      sliderInput(
        inputId = "intercept",
        label = NULL,
        min = -2,
        max = 2,
        value = 1
      ),

      ## Slope
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Slope:</span>"),
      p("Move this slider to see how the slope changes the steepness of the line.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      sliderInput(
        inputId = "slope",
        label = NULL,
        min = -2,
        max = 2,
        value = 2
      )
    ),

    ## Main Panel for Displaying Outputs
    mainPanel(

      ## Output: Graph (aligned with top of slider)
      plotOutput(outputId = "distPlot", height = "400px"),

      ## Text After Graph
      helpText("Notes:
              In a scatterplot, each point consists of two coordinates in
              the two-dimensional space. The first coordinate indicates
              the position of the point
              on the x-axis, and the second indicates the position of the point
              on the y-axis. For example, the point (0,1) aligns with 0 on the
               x-axis and 1 on the y-axis.",
               style = "font-size: 15px; color: #666; margin-top: 0px;")
    )
  )
)

## Define Server Logic Required to Draw the Graph
server = function(input, output) {

  # Pre-calculate static plot elements that don't change
  axis_ticks <- c(-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6, 7)

  output$distPlot <- renderPlot({
    # Set up plot parameters once
    par(
      mfrow = c(1, 1),
      cex = 1, adj = 1,
      yaxs = "r", xaxs = "r", las = 1
    )

    intercept <- input$intercept
    slope <- input$slope

    # Create empty plot with pre-calculated limits and styling
    plot(0, 0,
         main = "", col = "white",
         ylab = "", xlab = "", cex = 0.6,
         xaxt = "n", yaxt = "n",
         xlim = c(-2, 4), ylim = c(-6, 6),
         axes = FALSE, bty = "n", pch = 19)

    # Add axes (these don't change)
    axis(1, axis_ticks, col = "gray17", col.ticks = "gray", col.axis = "gray17", tck = -0.02)
    axis(2, axis_ticks, col = "gray17", col.ticks = "gray", col.axis = "gray17", tck = -0.02)

    # Add axis labels (these don't change)
    mtext("Y", side = 2, line = 2.5, outer = FALSE, cex = 1.2, at = 6, col = "gray17")
    mtext("X", side = 1, line = 2.5, outer = FALSE, cex = 1.2, adj = 1, col = "gray17")

    # Add equation title (this changes with inputs)
    mtext(paste("Y = ", intercept, " + ", slope, "X", sep = ""),
          side = 3, line = 1.5, outer = FALSE, adj = 0.5, cex = 1.4, font = 2)

    # Add the line (this changes with inputs)
    abline(a = intercept, b = slope, col = "gray60", lwd = 3, lty = "solid")

    # Add box outline (this doesn't change)
    box(col = "gray17")

    # Conditional elements - only add if needed
    if (input$red_dot) {
      lines(x = c(0, 0), y = c(intercept, -7), lty = "dashed", lwd = 2, col = "#bababa")
      lines(x = c(-7, 0), y = c(intercept, intercept), lty = "dashed", lwd = 2, col = "#bababa")
      points(0, intercept, col = "#0066CC", lwd = 2, pch = 19, cex = 1.5)
    }

    if (input$black_dot) {
      y_at_x2 <- intercept + slope * 2
      lines(x = c(2, 2), y = c(y_at_x2, -7), lty = "dashed", lwd = 2, col = "#bababa")
      lines(x = c(-7, 2), y = c(y_at_x2, y_at_x2), lty = "dashed", lwd = 2, col = "#bababa")
      points(2, y_at_x2, col = "#0066CC", lwd = 2, pch = 17, cex = 1.5)
    }

  }, bg = "white")
}

## Create Shiny App
shinyApp(ui = ui, server = server)
