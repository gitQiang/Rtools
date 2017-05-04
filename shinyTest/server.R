library(shiny)
library(datasets)
Logged = FALSE;
#PASSWORD <- data.frame(Brukernavn = "3golden", Passord = "81dc9bdb52d04dc20036dbd8313ed055")
PASSWORD <- data.frame(Brukernavn = "1", Passord = "c4ca4238a0b923820dcc509a6f75849b")
#=========================================================================================
source("misc_shiny.R")

#=========================================================================================


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {
        source("www/Login.R",  local = TRUE)
        source("www/Logout.R",  local = TRUE)
        
        observe({
                if (USER$Logged == TRUE) {
                        options(warn=-1) ####!!!!!!!!!
                        output$obs <- renderUI({

                                fluidPage(
                                        # absolutePanel(
                                        #         actionButton("logout", "Logout!"),
                                        #         uiOutput("uiLogout"),
                                        #          top = 1, right = 0),
                                        wellPanel (
                                                tabsetPanel(type="pills",
                                                            tabPanel(h3("简介"),
                                                                     br(),br(),
                                                                     p(em(strong("PTA-PPM")),"是恒逸人工智能系统的一部分，其主要负责实现PTA价格预测的子模块。该模块基于PTA产业链的大数据，整合时间序列分析和机器学习算法建立了一整套的预测和评估模型。当前，该模块提供每天、每周、每月、每季度的价格预测功能。产业链中产品价格预测的目标是考虑某种商品上下游以及其他外界影响因素变化从而预测商品的供需关系变化，为商品的生产和销售提供指导和参考。我们收集多重不同维度和不同指标的历史数据，通过数据的筛选和降噪，建立关联分析模型，时间序列模型和整合模型。模型出发点是产品价格是一个非平稳时间序列和多种外界因素影响的叠加的表征值。对非平稳时间序列，首先进行平稳化，然后考虑平稳时间序列的周期性和趋势性进行建模。对外界因素影响，收集100多个可测量的表征指标，首先进行单因素、多因素关联分析和数据冗余、缺失分析建立多因素回归模型。最终，综合考虑时间序列信息和外界因素的影响，建立非平稳时间序列和多因素关联的整合模型进行产业链产品价格预测。"),
                                                                     br(),
                                                                     br(),
                                                                     fluidRow(
                                                                             column(4,
                                                                                    img(src="PTA1.png", height = 300, width = "100%", align="center")
                                                                             ),
                                                                             column(4,
                                                                                    img(src="PTA2.png", height = 300, width = "100%", align="center")
                                                                             ),
                                                                             column(4,
                                                                                    img(src="PTA3.png", height = 300, width = "100%", align="center")
                                                                             )
                                                                     )
                                                                     #p(a("金电联行（北京）信息技术有限公司", href = "http://www.3golden.com.cn/")),
                                                            ),
                                                            tabPanel(
                                                                    h3("价格变动"),
                                                                    br(),br(),
                                                                    selectInput("var",
                                                                                label = "产品价格",
                                                                                choices = list("PTA", "POY","FDY"),
                                                                                selected = "PTA"),
                                                                    dateRangeInput("dates",
                                                                                   "起止时间",
                                                                                   start = "2004-01-01", #end = as.character(Sys.Date())
                                                                                   end = "2016-04-30",
                                                                                   min = "2003-11-15",
                                                                                   max = "2016-05-01"
                                                                    ),
                                                                    actionButton("button", "Go!"),
                                                                    plotOutput("Price")
                                                            ), 
                                                            
                                                            tabPanel( 
                                                                    h3("历史价格预测"),
                                                                    br(),br(),
                                                                    selectInput("var1",
                                                                                label = "产品",
                                                                                choices = list("PTA", "POY","FDY"),
                                                                                selected = "PTA"),
                                                                    dateRangeInput("dates1",
                                                                                   "起止时间",
                                                                                   start = "2015-12-01",
                                                                                   end = "2015-12-31",
                                                                                   min = "2013-01-01",
                                                                                   max = "2015-12-31"
                                                                    ),
                                                                    br(),
                                                                    h4("点击可以查看不同维度历史价格预测结果："),
                                                                    br(),
                                                                    #checkboxInput("Tracing", "显示进度", TRUE),
                                                                    #actionButton("Fitbutton", "Go!"),
                                                                    #br(),
                                                                    #br(),
                                                                    #textOutput("jobT"),
                                                                    tabsetPanel(selected=NULL,type="pills",
                                                                                tabPanel( h4("天预测"), plotOutput("Fitting1")),
                                                                                tabPanel( h4("周预测"), plotOutput("Fitting2")),
                                                                                tabPanel( h4("月预测"), plotOutput("Fitting3")),
                                                                                tabPanel( h4("季度预测"), plotOutput("Fitting4"))
                                                                    )
                                                            ),  
                                                            
                                                            tabPanel(h3("未来价格预测"), 
                                                                     br(),br(),
                                                                     selectInput("var2",
                                                                                 label = "产品",
                                                                                 choices = list("PTA", "POY","FDY"),
                                                                                 selected = "PTA"),
                                                                     br(),
                                                                     # tabsetPanel(selected=NULL,type="pills",
                                                                     #             tabPanel( h4("预测"),  tableOutput("predicts"))
                                                                     # ),
                                                                     actionButton("submit", "提交"),
                                                                     br(),br(),
                                                                     tableOutput("predicts"),
                                                                     br(),
                                                                     br()
                                                            ),
                                                            tabPanel(h3("添加新数据指标"), 
                                                                     fileInput('file1', '选择csv文件',
                                                                               accept=c('text/csv', 'text/comma-separated-values,text/plain')),
                                                                     tags$hr(),
                                                                     checkboxInput('header', '数据头', TRUE),
                                                                     radioButtons('sep', 'Separator',
                                                                                  c(Comma=',',
                                                                                    Semicolon=';',
                                                                                    Tab='\t'),
                                                                                  'Comma'),
                                                                     radioButtons('quote', 'Quote',
                                                                                  c(None='',
                                                                                    'Double Quote'='"',
                                                                                    'Single Quote'="'"),
                                                                                  'Double Quote'),
                                                                     tableOutput('contents'),
                                                                     br(),
                                                                     br()
                                                            )
                                                )
                                        )
                                )
                        })
                        options(warn=0)
                }
        })
        
        #===================== 价格变动
        observeEvent(input$button, { cat("Showing", input$var, "Price\n") })
        df <- eventReactive(input$button, { Price_curves(input$var,input$dates) })
        output$Price <- renderPlot({ df() })
        
        
        #===================== 历史价格预测
        output$Fitting1 <- renderPlot({  Fitting_curves(input$var1,input$dates1,1) })
        output$Fitting2 <- renderPlot({  Fitting_curves(input$var1,input$dates1,2) })
        output$Fitting3 <- renderPlot({  Fitting_curves(input$var1,input$dates1,3) })
        output$Fitting4 <- renderPlot({  Fitting_curves(input$var1,input$dates1,4) })
        
        #==================== 未来价格预测
        observeEvent(input$submit, { cat("Predicting", input$var2, "Price\n") })
        pred <- eventReactive(input$submit, { 
                if(input$var2=="PTA"){
                        tmp <- Predict_curves(input$var2)
                        tmp <- as.matrix(tmp)
                        rownames(tmp) <- c("时间","预测价格")
                        colnames(tmp) <- NULL
                        tmp
                }
        })
        output$predicts <- renderTable({ pred() }, caption="表1：PTA价格预测表格",include.rownames = TRUE, include.colnames = FALSE)
        
        
})