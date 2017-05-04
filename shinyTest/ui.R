shinyUI(fluidPage(
        titlePanel(
                titlePanel(h1("恒逸PTA价格预测AI系统", align="center"), windowTitle="恒逸PTA价格预测AI系统")
        ),
        br(),
        br(),
        br(),
        #fluidRow(
        # column(4,
        #        img(src="PTA1.png", height = 300, width = "100%", align="center")
        # ),
        
        #column(4,
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
        
        div(class = "span8", uiOutput("obs")),
        div(class = "span8", plotOutput("distPlot")),
        #)
        
        # column(4,
        #        img(src="PTA2.png", height = 300, width = "100%", align="center")
        # )
        # ),
        
        # 3golden logo
        column(12,HTML('<center><img src="3golden.jpg"><a href="http://www.3golden.com.cn/"><font color=black>金电联行（北京）信息技术有限公司</font></a></center>'))
        
))

