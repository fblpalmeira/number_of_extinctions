df<-read.csv("extinct-species-since-1500.csv", header=T)
df

library (dplyr)
library (vcd)

df1 <-df %>%
  select(Entity, Number.of.extinct.species) 

df2<-df1[!(df1$Entity=="Animals" | df1$Entity=="Chromists" | df1$Entity=="Corals" | df1$Entity=="Fungi"  | df1$Entity=="Total species"),]
df2

png(file = "extinct-species-since-1500.png", width = 620, height = 400)
df3 <- hclust(dist(df2))
df3
suppressPackageStartupMessages(library(dendextend))
df4 <- as.dendrogram(df3)

# Copy the object, and edit its labels
labels(df4) <- c("Molluscs", "Birds", "Plants", "Insects", "Fishes", "Mammals", "Other animals", "Arachnids", "Crustaceans", "Amphibians", "Reptiles")
avg_dend_obj <- as.dendrogram(df4)
avg_col_dend <- color_branches(avg_dend_obj, k = 4)
par(mar = c(5, 5, 5, 5))
plot(avg_col_dend, ylab="Entity", xlab="Number of species", horiz=TRUE, axes=TRUE)
dev.off()

library(magick)
library(magrittr) 

# Call back the plot
plot <- image_read("extinct-species-since-1500.png")
plot2<-image_annotate(plot, "Number of species that have gone extinct since 1500", color = "red", size = 20, 
                      location = "10+50", gravity = "north")
plot3<-image_annotate(plot2, "Data source: ourworldindata.org/extinctions | Visualization by @fblpalmeira", color = "gray", size = 10, 
                      location = "10+50", gravity = "southeast")
# And bring in a logo
logo_raw <- image_read("https://img.freepik.com/free-vector/snail-spa-salon-eco-cosmetics-vector-sketch-style-line-style-isolated-white-backgroun_273525-902.jpg?w=2000") 
out<-image_composite(plot3,image_scale(logo_raw,"x150"), offset = "+50+50")
image_browse(out)

# And overwrite the plot without a logo
image_write(out, "30daychallenge_day7.png")

