# Load libraries and data
library(shiny)
library(ggplot2)
data(iris)

# Define UI
ui <- fluidPage(
  titlePanel("Iris Data Visualization"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "property", label = "Select Property:",
                  choices = c("Sepal Length" = "Sepal.Length",
                              "Sepal Width" = "Sepal.Width",
                              "Petal Length" = "Petal.Length",
                              "Petal Width" = "Petal.Width"))
    ),
    mainPanel(
      plotOutput(outputId = "violin_plot")
    )
  )
)

# Define server
server <- function(input, output) {
  
  # Create plot
  output$violin_plot <- renderPlot({
    ggplot(data = iris, aes(x = Species, y = get(input$property), fill = Species)) +
      geom_violin() +
      geom_boxplot(width = 0.1, fill = "white") +
      labs(x = "Species", y = input$property, title = "Violin Plot/Boxplot for Iris Data") +
      theme_minimal()
  })
  
}

# Run the app
shinyApp(ui, server)
