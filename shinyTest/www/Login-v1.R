# See https://gist.github.com/withr/9001831 for more information

USER <- reactiveValues(Logged = Logged, 
                       Unique = format(Sys.time(), '%Y%m%d%H%M%S'),
                       Username = NA)

passwdInput <- function(inputId, label, value) {
        tagList(
                tags$label(label),
                tags$input(id=inputId, type="password", value=value)
        )
}

output$uiLogin <- renderUI({
        if(USER$Logged == FALSE) {
                wellPanel(
                        div(textInput(paste0("username", USER$Unique), "Username: ", value='')),
                        div(passwdInput(paste0("password", USER$Unique), "Password: ", value='')),
                        br(), br(),
                        actionButton("Login", "Login")
                )
        }
})

output$uiLogout <- renderUI({
        actionButton('logoutButton', 'Logout')
})

observeEvent(input$logoutButton, {
        if(!is.null(input$logoutButton) & input$logoutButton == 1) {
                USER$Logged <- FALSE
                USER$Username <- NA
                USER$Unique <- format(Sys.time(), '%Y%m%d%H%M%S')
        }
})

output$pass <- renderText({
        if(USER$Logged == FALSE) {
                if(!is.null(input$Login)) {
                        if(input$Login > 0) {
                                Username <- isolate(input[[paste0('username', USER$Unique)]])
                                Password <- isolate(input[[paste0('password', USER$Unique)]])
                                Id.username <- which(PASSWORD$Username == Username)
                                if(length(Id.username) == 1 & 
                                   Password == PASSWORD[Id.username,]$Password) {
                                        USER$Logged <- TRUE
                                        USER$Username <- Username
                                } else  {
                                        "Username or password failed!"
                                }
                        } 
                }
        }
})

