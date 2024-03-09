##### Load Packages #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(cowplot)
library(viridis)
library(ggsci)
library(ggsci)
library(ggpubr)
library(rstatix)
library(purrr)
library(tidyverse)
library(pheatmap)
library(reshape2)
library(scales) 
library(dunn.test)
library(Cairo)

##### Load Input Data #####
data <- read.csv(file = 'Hybrid_heatmap_accessory_gene_working.csv')
data

##### Obtain Counts of Accessory Genes #####
accessory_count<- data %>% 
  group_by(Home_location,Specific.Location,Accessory_gene_type,gene_id) %>% 
  summarise(total_count=n(),.groups = "drop") %>%
  #filter(total_count >= 2) %>%
  #filter(Accessory_gene_type == 'metabolism')%>% 
  as.data.frame()
accessory_count

##### Obtain the number of Genomes #####
genome_count<- data %>% 
  group_by(Home_location,Specific.Location) %>% 
  summarise(total_count=n(),.groups = "drop") %>%
  #filter(total_count >= 2) %>%
  #filter(Accessory_gene_type != 'defense_system')%>% 
  as.data.frame() 

##### Keys for Plotting #####
name_small_key <- subset(accessory_count, select = -c(Accessory_gene_type,total_count,gene_id))
name_small_key <- name_small_key[!duplicated(name_small_key), ]
name_small_key

class_small_key <- subset(accessory_count, select = -c(Home_location,total_count,Specific.Location))
class_small_key <- class_small_key[!duplicated(class_small_key), ]
class_small_key

##### Obtain the counts of accessory genes #####
count_key <- data %>% 
  group_by(gene_id) %>% 
  summarise(total_count=n()) %>%
  filter(total_count >= 25) %>%
  #filter(Accessory_gene_type != 'defense_system')%>% 
  as.data.frame() 
count_key

##### Create zero rows for values without accessory genes #####
expanded_data <- expand.grid(Specific.Location = unique(accessory_count$Specific.Location), gene_id = unique(accessory_count$gene_id))
expanded_data
complete_data <- expanded_data %>%
  full_join(accessory_count, by = c("Specific.Location", "gene_id"))
complete_data
complete_data <- complete_data %>% replace(is.na(.), 0.00000001)
complete_data
#complete_data <- cbind(complete_data,name_small_key)

##### Obtain Specific Location to expanded data #####
merged_df <- merge(complete_data,name_small_key, by = "Specific.Location")
merged_df <- subset(merged_df, select = -c(Home_location.x))
colnames(merged_df)[5] ="Home_location"
merged_df

##### Obtain gene_id to expanded data #####
merged_df_1 <- merge(merged_df, class_small_key, by = "gene_id")
merged_df_1$Accessory_gene_type <- sub("toxin/antitoxin", "TA", merged_df_1$Accessory_gene_type.y)
merged_df_1 <- subset(merged_df_1, select = -c(Accessory_gene_type.x,Accessory_gene_type.y))
merged_df_1

##### Factor Variables to reorder Graph axis #####
merged_df_2 <- merged_df_1 %>% inner_join(genome_count, 
                                          by=c('Home_location','Specific.Location'))

merged_df_2$freq <- merged_df_2$total_count.x / merged_df_2$total_count.y *100
merged_df_2$Specific.Location <- factor(merged_df_2$Specific.Location, 
                                        levels = c("freshwater", "saltwater", "wastewater",
                                                   "fungi", "plant","animal","human",
                                                   "soil", "sediment", "human facilities","other",
                                                   "unclassified P-P","plasmid","phage"))

merged_df_2$Home_location <- factor(merged_df_2$Home_location, 
                                    levels = c("Aquatic","Host-associated", "Terrestrial", "Other"))
merged_df_2

row_total <- merged_df_2 %>% 
  count(`Specific.Location`, wt = n)

genome_count <- merged_df_2 %>%
  group_by(Specific.Location) %>%
  summarise(Sum = sum(total_count.x))
genome_count

##### Graph the Heatmap #####
ggheatmap <- merged_df_2%>%filter(gene_id%in%count_key$gene_id) %>%
  ggplot(aes(fill=freq, y=Specific.Location, x=gene_id)) + 
  geom_tile(color = "black") +
  coord_flip()+
  theme_classic()+
  facet_grid(rows=vars(Accessory_gene_type),cols=vars(Home_location),scales="free",space="free",switch="both")+
  theme(axis.text.x = element_text(family = "Helvetica",color='black',angle=90,hjust=1,size=16,vjust=0.5),
        axis.text.y = element_text(family = "Helvetica",color='black',size=16),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.text = element_text(family = "Helvetica",size = 16),
        legend.title = element_text(family = "Helvetica",size = 16),
        strip.text = element_text(family = "Helvetica", size = 16),
        strip.background = element_blank())+
  guides(fill=guide_legend(title="Log Frequency of Accessory Genes"))
ggheatmap

##### Cleaned Color Heatmap ####
cleaned_graph <- ggheatmap +
  scale_fill_gradientn(
    trans = 'log10',
    colors = c("grey90", "#F0F8FF","#B0E0E6" ,"#56B4E9", "#0072B2","#001F3F"),
    breaks = c(0, 0.01, 1, 10, 100, 1000),
    labels = c("No Data", "0.01", "1", "10", "100", "1000")
  )

cleaned_graph
