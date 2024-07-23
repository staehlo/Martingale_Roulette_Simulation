library(shiny)
library(shinythemes)
source("martingale_simulation.R")
source("ggplot.R")

# Define UI for app ----
ui <- fluidPage(
  
  # Styling parameters
  theme = shinytheme("superhero"),
  tags$head(tags$style(HTML(paste('#submit{background-color: #3e5a74}',
                                  '#submit:hover{background-color:#2B3E50}')))),
  
  # App title
  titlePanel("Simulating the Martingale Roulette Strategy"),
  
  # Sidebar layout
  sidebarLayout(
    
    # Sidebar panel ----
    sidebarPanel(
      
      # Input: Slider for the budget ----
      sliderInput(inputId = "budget",
                  label = "Your budget:",
                  min = 0,
                  max = 500,
                  value = 200),
      
      # Input: Slider for the win limit ----
      sliderInput(inputId = "win_limit",
                  label = "At what win will you stop:",
                  min = 0,
                  max = 500,
                  value = 100),
      
      # Input: Radio button for color choice ----
      radioButtons(inputId = "winning_color",
                   label = "Choose a color:",
                   choices = c("black" = "black",
                               "red" = "red",
                               "green" = "green")),
      
      # Input: Submit button ----
      actionButton("submit", "Start")
      ), # end sidebarPanel

    # Main panel for displaying outputs ----
    mainPanel(
      
      tabsetPanel(
        # Tab "Simulation" ----
        tabPanel("Simulation",
      
          img(src = "./roulette.svg", height = 200, width = 200),
    
          h2("Starting values"),
          tableOutput("starting_values"),

          h2("Result"),
          tableOutput("result"),
          htmlOutput("thousand_sessions"),
          br(),
      
          plotOutput("my_ggplot")
        ), # end tabPanel "Simulation"

        # Tab "Explanation" ----
        tabPanel("Explanation",
          h2("The Martingale strategy at the Roulette table"),
          HTML(paste("<p>The <i>Martingale</i> is a betting strategy that can",
                     "be applied to various games of luck.</p>",
                     "<p>Its basic idea is to start with a minimum investment",
                     "and to double the input everytime you lost the last",
                     "round so that you will hopefully recover your losses at",
                     "the end. Whenever you win, you will add the money to",
                     "your budget and start again with the minimum investment.",
                     "</p>",
                     "<p>The game is over if you have won more than a",
                     "predefined amount of money or if you cannot make",
                     "the next investment required according to the strategy.",
                     "</p>",
                     "<p>At the roulette table, you will choose a color and",
                     "stick to it for the entire evening.</p>",
                     "<p>Beware that this simulation defines \"lost\" and",
                     "\"won\" only on the basis whether you reached your set",
                     "win target before you can no longer make the next",
                     "placement. This does not take into account that losing",
                     "might mean that you lost your entire budget while",
                     "winning only means that you have 1 more than the",
                     "predefined target value.")),
          h2("About the simulation"),
          HTML(paste("<p>Each simulation can take up to a couple of",
                     "seconds as it will compute the average win ratio based",
                     "on 1000 games with your input settings.</p>")),
          HTML(paste("The code can be found on GitHub:", br(),
                     tags$a(href = paste0("https://github.com/staehlo/",
                                          "Martingale_Roulette_Simulation"),
                            paste0("GitHub.com/staehlo/",
                                   "Martingale_Roulette_Simulation"))))
        ) # end tabPanel "Explanation"
      ) # end tabsetPanel
    ) # end mainPanel
  ) # end sidebarLayout
) # end fluid page

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  budget <- eventReactive(input$submit, input$budget)
  win_limit <- eventReactive(input$submit, input$win_limit)
  winning_color <- eventReactive(input$submit, input$winning_color)
  simulation <- eventReactive(
    input$submit, simulate_martingale(budget(), win_limit(), winning_color()))
  # output$user_input <- renderText(
  #   paste0("<p>Budget: ", budget(), "</p>",
  #          "<p>Win Limit: ", win_limit(), "</p>",
  #          "<p>Budget + Win Limit", budget() + win_limit(), "</p>",
  #          "<p>Color: ", color(), "</p>")
  # )
  
  starting_values <- reactive({
   data.frame("Parameter" = c("Budget",
                              "Win Limit",
                              "Budget + Win Limit",
                              "Winning Color"),
              "Value" = c(budget(),
                          win_limit(),
                          budget() + win_limit(),
                          winning_color())) 
  })
  output$starting_values <- renderTable(starting_values())

  result <- reactive({
    results = simulation()
    data.frame("Parameter" = c("Final outcome",
                               "Number of roulette spins",
                               "Final Budget",
                               "Next required placement would have been"),
               "Value" = c(results$final_outcome,
                           tail(results$spin_count - 1, n = 1),
                           tail(results$budget_before_spin, n = 1),
                           tail(results$placement, n = 1)))
  })
  output$result <- renderTable(result())
  
  # output$outcome <- renderText(
  #   paste0("Outcome of the game: ",
  #          simulation()$final_outcme)
  # )

  thousand_sessions <- reactive({
    results <- c()
    for (i in 1:1000){
      results <- c(results,
                   simulate_martingale(budget(),
                                       win_limit(),
                                       winning_color())$final_outcome)
    }
    sum(results == "You won") / length(results)
    })

  output$thousand_sessions <- renderText({
      paste("Your probability to win based on a simulation of thousand runs:",
            tags$br(), thousand_sessions())
      })

  output$my_ggplot <- renderPlot({
    create_ggplot(simulation(), budget(), win_limit())
    })
}

shinyApp(ui = ui, server = server)
