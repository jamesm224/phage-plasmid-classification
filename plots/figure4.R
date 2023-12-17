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
library(Cairo)

##### Load Input Data #####
data <- read.csv(file = 'Hybrid_heatmap_accessory_gene_working.csv')
data

##### Obtain Counts of Accessory Genes #####
accessory_count<- data %>% 
  group_by(Home_location,Specific.Location,Accessory_gene_type,gene_id) %>% 
  summarise(total_count=n()) %>%
  as.data.frame()
accessory_count

##### Obtain the number of Genomes #####
genome_count<- data %>% 
  group_by(Home_location,Specific.Location) %>% 
  summarise(total_count=n()) %>%
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
  as.data.frame() 
count_key

##### Create zero rows for values without accessory genes #####
expanded_data <- expand.grid(Specific.Location = unique(accessory_count$Specific.Location), gene_id = unique(accessory_count$gene_id))
expanded_data
complete_data <- expanded_data %>%
  full_join(accessory_count, by = c("Specific.Location", "gene_id"))
complete_data
complete_data <- complete_data %>% replace(is.na(.), 0.00001)
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
merged_df_2 <- merged_df_1 %>% inner_join(genome_count, by=c('Home_location','Specific.Location'))
merged_df_2$freq <- merged_df_2$total_count.x / merged_df_2$total_count.y *100
merged_df_2$Specific.Location <- factor(merged_df_2$Specific.Location, 
                                        levels = c("freshwater", "saltwater", "wastewater",
                                                   "fungi", "plant","animal","human",
                                                   "soil", "sediment", "human facilities","other",
                                                   "unclassified P-P","plasmid","phage"))
merged_df_2$Home_location <- factor(merged_df_2$Home_location, 
                                    levels = c("Aquatic","Host-associated", "Terrestrial", "Other"))
merged_df_2

##### Graph the Heatmap #####
ggheatmap <- merged_df_2%>%filter(gene_id%in%count_key$gene_id) %>%
  ggplot(aes(fill=freq, y=Specific.Location, x=gene_id)) + 
  geom_tile(color = "black") +
  coord_flip()+
  theme_classic()+
  facet_grid(rows=vars(Accessory_gene_type),cols=vars(Home_location),scales="free",space="free",switch="both")+
  theme(axis.text.x = element_text(family = "Times New Roman",color='black',angle=90,hjust=1,size=16),
        axis.text.y = element_text(family = "Times New Roman",color='black',size=16),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        legend.text = element_text(family = "Times New Roman",size = 16),
        legend.title = element_text(family = "Times New Roman",size = 16),
        strip.text = element_text(family = "Times New Roman", size = 16),
        strip.background = element_blank())+
  guides(fill=guide_legend(title="Log Frequency of Accessory Genes"))
ggheatmap


##### Adjust Colors and Formating for Plot #####
redone_graph <- ggheatmap +
  scale_fill_gradientn(
    trans = 'log10',
    colors = c("grey90", "#F0F8FF","#B0E0E6" ,"#56B4E9", "#0072B2","#001F3F"),
    #limits = c(0.01, max(merged_df_2$freq)),  # Start limits from a small positive value close to zero
    breaks = c(0, 0.01, 1, 10, 100, 1000),
    labels = c("No Data", "0.01", "1", "10", "100", "1000"),
    guide = guide_colorbar(title = "Your Legend Title Including Zero", barwidth = 10, barheight = 1))

redone_graph

##### Save and Export Figure #####
Cairo(file = "figure4.svg", type = "svg", width = 100, height = 100, units = "in", dpi = 500)
print(redone_graph)  # 'final_graph' is the ggplot object
dev.off()

##### Statistical Analysis #####

### Obtain the Mean P-P counts per accessory gene ###
phage_plasmid_subset<- cleaned_stats_data %>% 
  filter(Specific.Location != 'phage')%>% 
  filter(Specific.Location != 'plasmid')%>%
  group_by(gene_id) %>% 
  # Obtain the Mean Count #
  summarise(total_count=mean(total_count.x)) %>%
  as.data.frame()
phage_plasmid_subset$MGE <- 'P-P'
phage_plasmid_subset

### Obtain the Phage counts per accessory gene ###
phage_subset<- merged_df_2 %>% 
  filter(Specific.Location == 'phage')%>% 
  group_by(gene_id) %>% 
  # Obtain the Mean Count #
  summarise(total_count=mean(total_count.x)) %>%
  as.data.frame()
phage_subset$MGE <- 'phage'
phage_subset

### Obtain the Phage counts per accessory gene ###
plasmid_subset<- merged_df_2 %>% 
  filter(Specific.Location == 'plasmid')%>% 
  group_by(gene_id) %>% 
  # Obtain the Mean Count #
  summarise(total_count=mean(total_count.x)) %>%
  as.data.frame()
plasmid_subset$MGE <- 'plasmid'
plasmid_subset

### Combine the phage, plasmid, and P-P dataframes ###
combined_mge_df <- rbind(phage_plasmid_subset, phage_subset, plasmid_subset)
combined_mge_df

### Kruskal-Wallis test ##
kruskal_result <- kruskal.test(total_count ~ MGE, data = combined_mge_df)

### Dunn correction for comparing multiple variables ###
dunn_result <- dunn.test(combined_mge_df$total_count, g = combined_mge_df$MGE, method = "bonferroni")

# Print Kruskal-Wallis outputs #
print(kruskal_result)

# Print Dunn correction outputs #
print(dunn_result)
