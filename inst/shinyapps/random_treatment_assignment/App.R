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
  h3("Interactive Graph: Random Treatment Assignment",
     style = "color: #ea3a44; text-align: center; margin-bottom: 0px;"),
  p("By Elena Llaudet, co-author of ",
    a("Data Analysis for Social Science", href = "https://bit.ly/dss_textbook", target = "_blank", style = "color: #797979; text-decoration: none; font-style: italic;"),
    " (DSS)", style = "text-align: center; color: #797979; margin-bottom: 15px; font-size: 18px;"),

  ## Framed Text
  div(style = "background-color: #f1f3f5;
              border-left: 4px solid #ea3a44;
              padding: 15px;
              margin-bottom: 15px;",
      p("Random treatment assignment makes treatment and control groups comparable when sample size is large enough.",
        style = "margin: 0; font-size: 16px; color: #333333;")),

  ## Explanation
  helpText("Imagine five types of individuals: orange, blue, pink, green, and purple.
                 If we randomly assign them to treatment and control groups, both groups
                 will end up with similar proportions of each type of individual as long as the sample size
              is large enough. Let's take a closer look:",
           style = "font-size: 16px; color: #333333; margin-bottom: 15px"),

  ## Steps - All in one block for consistent spacing
  helpText(HTML("
    <ul style='line-height: 1.4;'>
      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 1:</b>
          Look at the graphs below. With 20 individuals (20% orange, 10% blue, 20% pink,
          30% green, 20% purple), the treatment group might end up with all the pink
          individuals while the control group gets all the blue ones, making the groups
          clearly not comparable even with random assignment.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 2:</b>
          Now move the slider to increase sample size and observe how the treatment
          and control groups start to look more similar.
          Try different values between 20 and 300.
          (Once you release the slider, R automatically randomly assigns individuals to the two groups and updates the graphs.)
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 3:</b>
          Increase the sample size to 300 and notice that both groups now have roughly
          the same proportions: 20% orange, 10% blue, 20% pink, 30% green, 20% purple.
          Random assignment splits each type roughly in half between the two groups, making them comparable.
      </li>
    </ul>
  "), style = "font-size: 16px; color: #333333"),

  br(), ## to add blank space before graph

  ## Sidebar Layout with Inputs and Outputs
  sidebarLayout(

    ## Sidebar Panel for Inputs
    sidebarPanel(

      ## Label
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Sample Size:</span>"),

      ## Explanation (moved here)
      p("Move the slider to see how random assignment creates comparable groups as sample size increases.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),

      ## Slider
      sliderInput(
        inputId = "sample_size",
        label = NULL,
        min = 20,
        max = 300,
        value = 20
      )
    ),

    ## Main Panel for Displaying Outputs
    mainPanel(

      ## Output: Graph (aligned with top of slider)
      plotOutput(outputId = "distPlot", height = "400px"),

      ## Text After Graph
      helpText("Note: n is the total sample size, n_t is the number of individuals in the treatment group, and n_c is the number in the control group.",
               style = "font-size: 15px; color: #666; margin-top: 10px;")
    )
  ),
)

## Define Server Logic Required to Draw the Graph
server = function(input, output) {

  ## Graph
  output$distPlot <- renderPlot({

    n <- input$sample_size
    # Create factor data but convert to numeric for hist() compatibility
    types <- factor(c(rep("Orange", n * 0.2), rep("Blue", n * 0.1), rep("Pink", n * 0.2),
                      rep("Green", n * 0.3), rep("Purple", n * 0.2)),
                    levels = c("Orange", "Blue", "Pink", "Green", "Purple"))
    volunteers <- as.numeric(types)  # Convert to numeric for hist()

    set.seed(678)
    treated <- sample(c(0, 1), size = length(volunteers), replace = TRUE, prob = c(0.5, 0.5))
    data <- data.frame(volunteers, treated)
    my_colors <- c(
      "Orange" = "#e34a33",
      "Blue"   = "#1f78b4",
      "Pink"   = "#f781bf",
      "Green"  = "#33a02c",
      "Purple" = "#6a3d9a"
    )

    # Adjusted layout to align main titles with slider top
    par(mfrow = c(1, 3), cex = 1.2, mar = c(5, 4, 3, 2), oma = c(0, 0, 0, 0))

    # Calculate max y value for consistent alignment
    max_y <- max(n/3 + 0.15 * n, 10)

    # Full Sample
    hist(data$volunteers,
         breaks = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5),
         main = "Full Sample",
         xlab = "",
         ylab = "",
         col = my_colors,
         col.main="#333333",
         col.axis ="#333333",
         ylim = c(0, max_y),
         border = "white",
         xaxt = "n",
         yaxt = "n",
         cex.main = 1.1)  # Smaller title

    # Add y-axis
    axis(2, cex.axis = 1.1, col.axis = "#333333")

    # Position "Count" at the actual top y-axis value
    mtext("count", side = 2, line = 2.5, at = max_y * 0.95, cex = 1.1, col = "#333333")

    # Add custom x-axis labels closer to axis with horizontal line
    axis(1, at = 1:5, labels = c("orange", "blue", "pink", "green", "purple"),
         cex.axis = 1.0, las = 2, tick = TRUE, line = 0, col = "#333333", col.axis = "#333333")

    # Add sample size annotation positioned below main title
    mtext(paste("n =", length(data$volunteers)), side = 3, line = 0, cex = 1.3, col = "#333333")

    # Treatment Group
    hist(data$volunteers[data$treated == 1],
         breaks = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5),
         main = "Treatment Group",
         xlab = "",
         ylab = "",
         col = my_colors,
         col.main = "#333333",
         col.axis = "#333333",
         ylim = c(0, max_y),
         border = "white",
         xaxt = "n",
         yaxt = "n",
         cex.main = 1.1)  # Smaller title

    # Add y-axis
    axis(2, cex.axis = 1.1, col.axis = "#333333")

    mtext("count", side = 2, line = 2.5, at = max_y * 0.95, cex = 1.1, col = "#333333")

    axis(1, at = 1:5, labels = c("orange", "blue", "pink", "green", "purple"),
         cex.axis = 1.0, las = 2, tick = TRUE, line = 0, col = "#333333", col.axis = "#333333")

    mtext(paste("n_t =", length(data$volunteers[data$treated == 1])),
          side = 3, line = 0, cex = 1.3, col = "#333333")

    # Control Group
    hist(data$volunteers[data$treated == 0],
         breaks = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5),
         main = "Control Group",
         xlab = "",
         ylab = "",
         col = my_colors,
         col.main = "#333333",
         col.axis = "#333333",
         ylim = c(0, max_y),
         border = "white",
         xaxt = "n",
         yaxt = "n",
         cex.main = 1.1)  # Smaller title

    # Add y-axis
    axis(2, cex.axis = 1.1, col.axis = "#333333")

    mtext("count", side = 2, line = 2.5, at = max_y * 0.95, cex = 1.1, col = "#333333")

    axis(1, at = 1:5, labels = c("orange", "blue", "pink", "green", "purple"),
         cex.axis = 1.0, las = 2, tick = TRUE, line = 0, col = "#333333", col.axis = "#333333")

    mtext(paste("n_c =", length(data$volunteers[data$treated == 0])),
          side = 3, line = 0, cex = 1.3, col = "#333333")

  }, bg = "white")
}

## Create Shiny App
shinyApp(ui = ui, server = server)
