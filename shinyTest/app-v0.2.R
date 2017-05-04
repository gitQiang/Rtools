library(shiny)
library(datasets)

ui <- fluidPage(
#         titlePanel("App Shiny Test"),
#         sidebarLayout(
#                 position= "right", 
#                 sidebarPanel(
#                         h2("Installation"),
#                         p("Shiny is available on CRAN, so you can install it in the usual way from your R console:"),
#                         code('install.packages("shiny")'),
#                         br(),
#                         br(),
#                         br(),
#                         img(src="3golden.jpg", height = 100, width = 100, align="center")
#                 ),
#                 mainPanel (
#                         h1("Introducing Shiny"),
#                         p("Shiny is a new package from RStudio that makes it ", 
#                           em("incredibly easy"), 
#                           " to build interactive web applications with R."),
#                         br(),
#                         p("For an introduction and live examples, visit the ",
#                           a("Shiny homepage.", 
#                             href = "http://www.rstudio.com/shiny")),
#                         br(),
#                         h2("Features"),
#                         p("* Build"),
#                         
#                         renderUI({
#                                 if (USER$Logged == FALSE) {
#                                         wellPanel(
#                                                 textInput("Username", "User Name:"),
#                                                 textInput("Password", "Pass word:"),
#                                                 br(),
#                                                 actionButton("Login", "Log in")
#                                         )
#                                 }
#                         })
#                 )
#         ),
#         
# 	actionButton(inputId = "Action", label = "Update"),
        
        bootstrapPage(
                # Add custom CSS & Javascript;
                tagList(
                        tags$head(
                                tags$link(rel="stylesheet", type="text/css",href="style.css"),
                                tags$script(type="text/javascript", src = "md5.js"),
                                tags$script(type="text/javascript", src = "passwdInputBinding.js")
                        )
                ),
                
                ## Login module;
                div(class = "login",
                    uiOutput("uiLogin"),
                    textOutput("pass")
                ), 
                
                div(class = "span4", uiOutput("obs")),
                div(class = "span8", plotOutput("distPlot"))
                
        )
        
)

server <- function(input,output){
        Logged = FALSE;
        PASSWORD <- data.frame(Brukernavn = "withr", Passord = "25d55ad283aa400af464c76d713c07ad")
        # Define server logic required to summarize and view the selected dataset
        shinyServer(function(input, output) {
                source("www/Login.R",  local = TRUE)
                
                observe({
                        if (USER$Logged == TRUE) {
                                output$obs <- renderUI({
                                        sliderInput("obs", "Number of observations:", 
                                                    min = 10000, max = 90000, 
                                                    value = 50000, step = 10000)
                                })
                                
                                output$distPlot <- renderPlot({
                                        dist <- NULL
                                        dist <- rnorm(input$obs)
                                        hist(dist, breaks = 100, main = paste("Your password:", input$passwd))
                                })
                        }
                })
        })
}
shinyApp(ui=ui,server=server)