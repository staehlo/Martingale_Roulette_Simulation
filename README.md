# Martingale_Roulette_Simulation
Shiny App that simulates the Martingale betting strategy for Roulette gambles

The app can be viewed at [rahace.shinyapps.io/martingale_roulette_simulation](https://rahace.shinyapps.io/martingale_roulette_simulation/)

<img style="width:60%; height:auto;" src="https://github.com/staehlo/Martingale_Roulette_Simulation/blob/main/screenshot_for_readme.jpg" alt="Screenshot of Martingale Shiny App">

## Technology
The app was built with R version 4.4.1

The following packages - and versions - were used:

* ggplot2 - 3.5.1
* shiny - 1.8.1.1
* shinythemes - 1.2.0

## How to download and run it locally

(absolute beginner's guide)

You need to have R, and git installed. RStudio is not necessary but helpful.

1\. Open a Linux terminal or Windows command line shell and go to the folder where you wish to download the application to.

2.\ Install the necessary R packages from within the R console. For example, if you are missing ggplot2, you can enter:  
`install.packages('ggplot2')`

3.\ Clone the repository to your computer by entering in your Linux terminal or Windows command line:  
`git clone https://github.com/staehlo/martingale_roulette_simulation` 

Now you have two possibilites:

__Option A\. Launch the Shiny App via the command line:__  
4\. Change the working directory to the *martingale_roulette_simulation* folder by typing:  
`cd martingale_roulette_simulation`

5\. Start R from the command line by simple entering `R`.

6\. In the R console, type `library("shiny")`  

7\. In the R console, type `runApp("app")`

8\. The app should automatically start in your default web browser.

__Option B\. Launch from within RStudio:__  
4\. In the top menu go to 'File' -> 'Open File' and select the 'app.R' file from the Shiny App.

5\. Click on the 'Run App' button in the top right corner above the script.

6\. The app should start in RStudio's 'Viewer' panel.
