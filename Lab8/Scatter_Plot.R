library(shiny)
library(ggplot2)
library(dplyr)

# Load iris dataset
data(iris)

# Define UI
ui <- fluidPage(
  
  # Add title
  titlePanel("Iris Data Visualization"),
  
  # Add sidebar layout
  sidebarLayout(
    
    # Add sidebar panel
    sidebarPanel(
      
      # X-axis selection
      selectInput("x_var", "Select X-axis variable", 
                  choices = c("Sepal Length" = "Sepal.Length", 
                              "Sepal Width" = "Sepal.Width", 
                              "Petal Length" = "Petal.Length", 
                              "Petal Width" = "Petal.Width")),
      
      # Y-axis selection
      selectInput("y_var", "Select Y-axis variable", 
                  choices = c("Sepal Length" = "Sepal.Length", 
                              "Sepal Width" = "Sepal.Width", 
                              "Petal Length" = "Petal.Length", 
                              "Petal Width" = "Petal.Width")),
      
      # Species selection
      selectInput("species", "Select species", 
                  choices = c("All", levels(iris$Species)), 
                  selected = "All"),
      
      # Point shape selection
      selectInput("shape", "Select point shape", 
                  choices = c("Circle", "Square", "Triangle"), 
                  selected = "Circle"),
      
      # Point size selection
      sliderInput("size", "Select point size", 
                  min = 1, max = 10, value = 5, step = 1)
      
    ),
    
    # Add main panel
    mainPanel(
      
      # Scatter plot output
      plotOutput(outputId = "scatter_plot", width = "100%", height = "500px")
      
    )
    
  )
  
)

# Define server
server <- function(input, output) {
  
  # Filter data based on species selection
  filtered_data <- reactive({
    if (input$species == "All") {
      iris_data <- iris
    } else {
      iris_data <- iris %>% filter(Species == input$species)
    }
    iris_data
  })
  
  # Create scatter plot
  output$scatter_plot <- renderPlot({
    
    # Get x and y variables from input
    x_var <- input$x_var
    y_var <- input$y_var
    
    # Get filtered data
    iris_data <- filtered_data()
    
    # Get point shape and size from input
    point_shape <- ifelse(iris_data$Species == "setosa", 
                          input$shape, "none")
    point_size <- ifelse(iris_data$Species == "versicolor", 
                         input$size, 2)
    
    # Create scatter plot
    ggplot(iris_data, aes(x = !!sym(x_var), y = !!sym(y_var), 
                          color = Species, shape = point_shape, 
                          size = point_size)) +
      geom_point() +
      labs(x = x_var, y = y_var, title = "Scatter plot of Iris data") +
      scale_color_manual(values = c("#00AFBB", "#E7B800", "#FC4E07")) +
      theme_bw() +
      theme(legend.position = "right")
    
  })
  
}

# Run the app
shinyApp(ui, server)
