#### Log out module ###

output$uiLogout <- renderUI({
        logout1();
        fluidPage(

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
                
                div(class = "span2", uiOutput("obs")),
                div(class = "span2", plotOutput("distPlot")),
                
                # 3golden logo
                column(12,HTML('<center><img src="3golden.jpg"><a href="http://www.3golden.com.cn/"><font color=black>金电联行（北京）信息技术有限公司</font></a></center>'))
                
        )
})

observeEvent(input$logout, {
        cat("Running logout\n")
})

logout1 <- eventReactive(input$logout, { 
        if(!is.null(input$logout) & input$logout == 1) {
                USER$Logged <- FALSE
                USER$Username <- NA
                #USER$Unique <- format(Sys.time(), '%Y%m%d%H%M%S')
        }
})