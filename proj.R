## Project, Group 11
## Stats 506, Fall 2018
##
## Seeds data is available at:
## https://archive.ics.uci.edu/ml/datasets/seeds
##
## Author: Reed Millek
## Updated: November 25, 2018

# Load libraries: -------------------------------------------------------------
library(car)
library(MASS)
library(ggplot2)

# Set working directory: ------------------------------------------------------
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Read in and format data: ----------------------------------------------------
seeds = read.csv('./seeds.csv', sep="\t", header=TRUE)
seeds$group = as.factor(seeds$group)
levels(seeds$group) = c("Kama", "Rosa", "Canadian")
summary(seeds)
scatterplotMatrix(seeds[1:7])

# Set up train/test sequence: -------------------------------------------------
set.seed(123) 
seedss = sample.int(n = nrow(seeds), size = floor(.7*nrow(seeds)), replace = F)
train = seeds[seedss, ]
test  = seeds[-seedss, ]

# Use train data for classification: ------------------------------------------
lseeds = lda(group~., train)
lseeds

# Use test data for predictions: ----------------------------------------------
lseeds.values = predict(lseeds, test[,1:7])

# Plot predicted data to see if classified correctly: -------------------------
plot.data = data.frame(LD1=lseeds.values$x[,1], LD2=lseeds.values$x[,2], 
                       WheatType=test$group)
head(plot.data)                       
p = ggplot(data=plot.data, aes(x=LD1, y=LD2)) +
  geom_point(aes(color=WheatType)) +
  ggtitle("Discriminant Scores") +
  theme(plot.title = element_text(hjust = 0.5)) 
p
