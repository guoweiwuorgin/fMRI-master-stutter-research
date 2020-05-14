library(shiny)
library(dplyr)
library(tidyverse)


plot_data <- function(dataf,GP,DV,subgroup,gp1,gp2,method){
  if (subgroup ==0) {
    data_tmp <- eval(parse(text =paste0("split(dataf,dataf$",GP,")")))
    number <- eval(parse(text = paste0("length(levels(factor(dataf$",GP,")))")))
    group_pic <- as.list(paste0("factor",seq(1:number)))
    if (method == "Hist") {
      for (i in seq(1:number)) {
        level_name <-  eval(parse(text = paste0("levels(factor(dataf$",GP,"))")))
        eval(parse(text = paste0("data_tmp[[i]] %>% ggplot(aes(x=",DV,"))+
        geom_histogram(aes(fill=",GP,"))+labs(title=\"",level_name[[i]],"\") -> group_pic[[i]]"))) 
      }
    } else {
      for (i in seq(1:number)) {
        level_name <-  eval(parse(text = paste0("levels(factor(dataf$",GP,"))")))
        eval(parse(text = paste0("data_tmp[[i]] %>% ggplot(aes(x=",GP,",y=",DV,"))+
        geom_boxplot(aes(fill=",GP,"))+labs(title=\"",level_name[[i]],"\") -> group_pic[[i]]")))
      }
    }
    library(patchwork)
    gplot_data1 <- group_pic[[1]]
    for (n in c(2:length(group_pic))) {
      gplot_data <- group_pic[[n]]
      gplot_data1 <- gplot_data1 + gplot_data
      gplot_dataf <- gplot_data1  
    }  
  } else if (subgroup == 1) {
    data_tmp <- eval(parse(text =paste0("split(dataf,dataf$",GP,")")))
    number <- eval(parse(text = paste0("length(levels(factor(dataf$",GP,")))")))
    group_pic <- as.list(paste0("factor",seq(1:number)))
    if (method == "Hist") {
      for (i in seq(1:number)) {
        level_name <-  eval(parse(text = paste0("levels(factor(dataf$",GP,"))")))
        eval(parse(text = paste0("data_tmp[[i]] %>% ggplot(aes(x=",DV,"))+
                             geom_histogram(aes(fill=",gp1,"))+facet_grid(.~",gp1,")+labs(title=\"",level_name[[i]],"\") -> group_pic[[i]]")))
      } 
    }else {
      for (i in seq(1:number)) {
        level_name <-  eval(parse(text = paste0("levels(factor(dataf$",GP,"))")))
        eval(parse(text = paste0("data_tmp[[i]] %>% ggplot(aes(x=",gp1,",y=",DV,"))+
                          geom_boxplot(aes(fill=",gp1,"))+labs(title=\"",level_name[[i]],"\") -> group_pic[[i]]")))
      }
    }
    library(patchwork)
    gplot_data1 <- group_pic[[1]]
    for (n in c(2:length(group_pic))) {
      gplot_data <- group_pic[[n]]
      gplot_data1 <- gplot_data1 + gplot_data
      gplot_dataf <- gplot_data1
    }
  } else if (subgroup == 2) {
    data_tmp <- eval(parse(text =paste0("split(dataf,dataf$",GP,")")))
    
    number <- eval(parse(text = paste0("length(levels(factor(dataf$",GP,")))")))
    
    group_pic <- as.list(paste0("factor",seq(1:number)))
    if (method == "Hist"){
      for (i in seq(1:number)) {
        
        data_tmp1 <- eval(parse(text =paste0("split(data_tmp[[i]],dataf$",gp1,")")))
        
        number1 <-eval(parse(text = paste0("length(levels(factor(dataf$",gp1,")))")))
        
        group_pic1 <- as.list(paste0("factor",seq(1:number1)))
        
        for (i1 in seq(1:(number1))) {
          level_name <-  eval(parse(text = paste0("levels(factor(dataf$",gp1,"))")))
          eval(parse(text = paste0("data_tmp1[[i1]] %>% ggplot(aes(x=",DV,"))+
       geom_histogram(aes(fill=",gp2,"))+facet_grid(.~",gp2,")+labs(title=\"",level_name[[i1]],"\") -> group_pic1[[i1]]"))) 
          group_pic[[i]] <- group_pic1
          if (i1 == number1) {
            next
          }
        }
      }  
    }else{
      for (i in seq(1:number)) {
        
        data_tmp1 <- eval(parse(text =paste0("split(data_tmp[[i]],dataf$",gp1,")")))
        
        number1 <-eval(parse(text = paste0("length(levels(factor(dataf$",gp1,")))")))
        
        group_pic1 <- as.list(paste0("factor",seq(1:number1)))
        for (i1 in seq(1:(number1))) {
          level_name <-  eval(parse(text = paste0("levels(factor(dataf$",gp1,"))")))
          eval(parse(text = paste0("data_tmp1[[i1]] %>% ggplot(aes(x=",gp2,",y=",DV,"))+
       geom_boxplot(aes(fill=",gp2,"))+labs(title=\"",level_name[[i1]],"\") -> group_pic1[[i1]]"))) 
          group_pic[[i]] <- group_pic1
          if (i1 == number1) {
            next
          } 
        }
      }
    }
    gplot_data2 <- as.list(paste0("factor",seq(1:number)))
    for (i2 in 1:number) {
      group_pic1 <- group_pic[[i2]]
      gplot_data1 <- group_pic1[[1]]
      for (n in c(2:length(group_pic1))) {
        gplot_data <- group_pic1[[n]]
        gplot_data1 <- gplot_data1 + gplot_data
        gplot_data2[[i2]] <- gplot_data1
      }
      if (n == length(group_pic1)) {
        next
      }
    }
    gplot_dataf <- gplot_data2
  }
  return(print(gplot_dataf))
}

ui <- fluidPage(
  titlePanel('SHINY Data Clean'),
  
  sidebarLayout(
    
    sidebarPanel(
      
      fileInput("filen", "Choose the File of your data",
                accept = c(
                  "text/csv",
                  "text/comma-separated-values,text/plain",
                  ".csv",'.xls','.txt','.xlsx')),
      numericInput("obs", "Set the number of observations to view:",20),
      
      textInput('DV','Input the dependent variable:','Y'),
      
      textInput('Group','Input the group variable:','X'),
      
      selectInput('Subgroup_number','Select the number of subgroup factors',choices = c(0,1,2)),
      
      textInput('Sub1','Input the first subgroup factor:', 'A'),
      
      textInput('Sub2','Input the 2nd subgroup factorr:', 'B'),
      
      selectInput('Plot_method','Select the method to visualize the data',choices = c("Box","Hist")),
      
      actionButton(inputId = "clicks",label = "Click me")),
     
      mainPanel(
      tableOutput("Dataview"),
      textOutput('Data_str'),
      plotOutput('figure')
      )
    )
  )

server <- function(input, output) {
      obs = reactive(input$obs)

      dataf = reactive({
        
        inFile <- input$filen
        
        if (is.null(inFile))
          return(NULL)
        rio::import(inFile$datapath)
      })
      
      DV = reactive(input$DV)
      
      GP = reactive(input$Group)
      
      subgroup = reactive(input$Subgroup_number)
      
      gp1 = reactive(input$Sub1)
      
      gp2 = reactive(input$Sub2)
      
      method = reactive({
        switch(input$Plot_method,
               "Box" = "Box",
               "Hist" = 'Hist')})
        
      figure <- observeEvent(input$clicks, {
        plot_data(dataf(),GP(),DV(),subgroup(),gp1(),gp2(),method())
        })

        output$Dataview = renderTable({
          head(dataf(),n = obs())})
        
        output$Data_str = renderPrint({
          print(str(dataf()))})
          
        output$figure = renderPlot({figure})
    }
    shinyApp(ui = ui, server = server)