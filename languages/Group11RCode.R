## CourseProject, Group 11
## Stats 506, Fall 2018
##
## Seeds data is available at:
## https://archive.ics.uci.edu/ml/datasets/seeds
##
## Author: Reed Millek
## Updated: 7 December 2018

# Libraries: ------------------------------------------------------------------
library(MASS)
library(candisc)
library(ggplot2)
library(car)

#Load and summarize data: -----------------------------------------------------
seeds = read.csv("./seeds.csv", sep="\t", header=TRUE)
seeds$group = as.factor(seeds$group)
levels(seeds$group) = c("Kama", "Rosa", "Canadian")
summary(seeds)
scatterplotMatrix(seeds[1:7])

# Train-Test split: -----------------------------------------------------------
set.seed(123) 
seedss = sample.int(n = nrow(seeds), size = floor(.7*nrow(seeds)), replace = F)
train = seeds[seedss, ]
test  = seeds[-seedss, ]

# Train data: -----------------------------------------------------------------
lseeds = lda(group~., train)
lseeds

# Standardize variables: ------------------------------------------------------
x=lm(cbind(area,peri,comp,l,w,Asym,lgroove)~group, train)
y=candisc(x, terms="Groups")
summary(y)

# Classify test set: ----------------------------------------------------------
lseeds.values = predict(lseeds, test[,1:7])

# Plot test set: --------------------------------------------------------------
plot.data = data.frame(LD1=lseeds.values$x[,1], LD2=lseeds.values$x[,2], WheatType=test$group)
head(plot.data)                       
p <- ggplot(data=plot.data, aes(x=LD1, y=LD2)) +
  geom_point(aes(color=WheatType)) +
  theme_bw()
p

# Error Checking
error_tab = table(test$group,lseeds.values$class)