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
  h3("Interactive Graph: Random Sampling",
     style = "color: #ea3a44; text-align: center; margin-bottom: 0px;"),
  p("By Elena Llaudet, co-author of ",
    a("Data Analysis for Social Science", href = "https://bit.ly/dss_textbook", target = "_blank", style = "color: #797979; text-decoration: none; font-style: italic;"),
    " (DSS)", style = "text-align: center; color: #797979; margin-bottom: 15px; font-size: 18px;"),

  ## Framed Text
  div(style = "background-color: #f1f3f5;
              border-left: 4px solid #ea3a44;
              padding: 15px;
              margin-bottom: 15px;",
      p("Random sampling creates a representative sample of the target population when the sample size is large enough.",
        style = "margin: 0; font-size: 16px; color: #333333;")),

  ## Explanation
  helpText("Imagine five types of individuals: orange, blue, pink, green, and purple.
                 If we randomly select individuals from the population into a sample, the sample
                 will end up with similar proportions of each type of individual as long as the sample size
                is large enough. Let's take a closer look:",
           style = "font-size: 16px; color: #333333; margin-bottom: 15px"),

  helpText(HTML("
    <ul style='line-height: 1.4;'>
      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 1:</b>
          Look at the graphs below. With 20 individuals randomly sampled from a population of 1,000,
          the sample might end up without any blue individuals even though they represent 10% of the population,
          making the sample clearly not representative despite random sampling.
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 2:</b>
          Now move the slider to increase sample size and observe how the sample
          composition starts to match the population.
          Try different values between 20 and 300.
          (Once you release the slider, R automatically randomly selects individuals into the sample and updates the graphs.)
      </li>

      <li style='margin-bottom: 10px;'><b style='color: #ea3a44;'>STEP 3:</b>
          Increase the sample size to 300 and notice that the sample now has roughly
          the same proportions as the population: 20% orange, 10% blue, 20% pink, 30% green, 20% purple.
          Random sampling creates a representative sample when sample size is large enough.
      </li>
    </ul>
  "), style = "font-size: 16px; color: #333333"),

  br(),

  sidebarLayout(
    sidebarPanel(
      HTML("<span style='color: #333333; font-size: 15px; display: inline-block; margin-bottom: 2px;'>Sample Size:</span>"),
      p("Move the slider to see how random sampling creates representative samples as sample size increases.",
        style = "font-size: 14px; color: #666; text-align: left; margin-top: 0px; margin-bottom: 10px;"),
      sliderInput("sample_size", label = NULL, min = 20, max = 300, value = 20)
    ),

    mainPanel(
      plotOutput("distPlot", height = "400px"),
      helpText("Note: N is the total population size and n is the sample size.",
               style = "font-size: 15px; color: #666; margin-top: 10px;")
    )
  )
)

## Define Server Logic
server = function(input, output) {

  output$distPlot <- renderPlot({
    set.seed(12678)  # fixed seed for reproducibility

    N <- 1000
    n <- input$sample_size

    types <- factor(c(rep("Orange", N * 0.2), rep("Blue", N * 0.1), rep("Pink", N * 0.2),
                      rep("Green", N * 0.3), rep("Purple", N * 0.2)),
                    levels = c("Orange", "Blue", "Pink", "Green", "Purple"))
    population <- as.numeric(types)

    selected_indices <- sample(seq_len(N), size = n)
    data <- data.frame(population = population)
    data$selected <- 0
    data$selected[selected_indices] <- 1

    my_colors <- c(
      "Orange" = "#e34a33",
      "Blue"   = "#1f78b4",
      "Pink"   = "#f781bf",
      "Green"  = "#33a02c",
      "Purple" = "#6a3d9a"
    )

    par(mfrow = c(1, 2), cex = 1.2, mar = c(5, 4, 3, 2), oma = c(0, 0, 0, 0))

    max_y_pop <- max(N/3 + 0.15 * N, 10)
    max_y_sample <- max(n/3 + 0.15 * n, 10)

    hist(data$population,
         breaks = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5),
         main = "Population",
         xlab = "",
         ylab = "",
         col = my_colors,
         col.main = "#333333",
         col.axis = "#333333",
         ylim = c(0, max_y_pop),
         border = "white",
         xaxt = "n",
         yaxt = "n",
         cex.main = 1.1)

    axis(2, cex.axis = 1.1, col.axis = "#333333")
    mtext("count", side = 2, line = 2.5, at = max_y_pop * 0.95, cex = 1.1, col = "#333333")
    axis(1, at = 1:5, labels = c("orange", "blue", "pink", "green", "purple"),
         cex.axis = 1.0, las = 2, line = 0, col = "#333333", col.axis = "#333333")
    mtext(paste("N =", N), side = 3, line = 0, cex = 1.3, col = "#333333")

    hist(data$population[data$selected == 1],
         breaks = c(0.5, 1.5, 2.5, 3.5, 4.5, 5.5),
         main = "Sample",
         xlab = "",
         ylab = "",
         col = my_colors,
         col.main = "#333333",
         col.axis = "#333333",
         ylim = c(0, max_y_sample),
         border = "white",
         xaxt = "n",
         yaxt = "n",
         cex.main = 1.1)

    axis(2, cex.axis = 1.1, col.axis = "#333333")
    mtext("count", side = 2, line = 2.5, at = max_y_sample * 0.95, cex = 1.1, col = "#333333")
    axis(1, at = 1:5, labels = c("orange", "blue", "pink", "green", "purple"),
         cex.axis = 1.0, las = 2, line = 0, col = "#333333", col.axis = "#333333")
    mtext(paste("n =", n), side = 3, line = 0, cex = 1.3, col = "#333333")

  }, bg = "white")
}

## Run the App
shinyApp(ui = ui, server = server)
