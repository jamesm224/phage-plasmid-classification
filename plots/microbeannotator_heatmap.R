##### Code for graphing Microbeannotator Code #####

##### Load Packages and Data #####
library(ggplot2)
library(scales)
library(ggsci)
library(forcats)
library(dplyr)
library(viridis)
library(reshape2)
data <- read.table(file = 'metabolic_summary__module_completeness.tab',sep="\t",header = TRUE)
data
metadata <- read.csv(file='hybrid_source_location_key_clustered.csv')
metadata <- subset(metadata, select = c(Genome,Home_location,Specific.Location))
metadata

##### Convert data to long format #####
long_df <- melt(data, id.vars = c("name","pathway.group","module"), variable.name = "Genome")
long_df$Genome <- gsub(".faa.ko", "", long_df$Genome)
long_df$Genome <- gsub("X", "", long_df$Genome)
long_df

##### Merge and subset data by pathways #####
df_merge <- merge(long_df,metadata,by="Genome")
df_merge
subset <- df_merge %>% filter((name=='dTDP-6-deoxy-D-allose biosynthesis'))
subset=subset%>%  
  group_by(Genome,Specific.Location,pathway.group,module,value) %>% 
  summarise(total_count=sum(value),.groups = 'drop') %>%
  filter(value != 0) %>%
  #summarise(total_count=n(),.groups = 'drop') %>%
  #filter(total_count>= 1) %>%
  as.data.frame()
subset

subset_count = subset%>%
  group_by(module) %>% 
  summarise(total_count=n(),.groups = 'drop') %>%
  as.data.frame()
subset_count

##### Obtain common pathways #####
common_pathways = df_merge %>%
  filter(value >= 25) %>%
  group_by(name) %>%
  summarise(total_count=n(),.groups = 'drop') %>%
  filter(total_count>= 1) %>%
  as.data.frame()
common_pathways

high_count=df_merge%>%filter(name%in%common_pathways$name) %>% #group_by(Genome) %>% 
  filter(value >= 25) %>%
  group_by(Genome) %>% 
  #summarise(total_count=sum(value)) %>%
  summarise(total_count=n(),.groups = 'drop') %>%
  filter(total_count>= 1) %>%
  as.data.frame()
high_count

##### Designed for overall heatmaps #####
heatmap <- #long_df%>%filter(pathway.group%in%high_count$pathway.group) %>%
  df_merge%>%
  filter(Genome%in%high_count$Genome) %>%
  filter(name%in%common_pathways$name) %>%
  ggplot(aes(x=Genome, y=name, fill= value)) + 
  geom_tile()+
  scale_fill_viridis(option="magma")+
  theme_classic()+
  theme(axis.text.y = element_blank(),
        axis.text.x = element_text(family = "Times New Roman",color='black',size=10,angle=90))+
  facet_grid(rows=vars(Specific.Location),cols=vars(pathway.group),scales="free",space="free")+
  coord_flip()

heatmap

##### Code for subsetting heatmap to specific functions #####
subset_heatmap <-  df_merge%>%
  filter(Genome%in%high_count$Genome) %>%
  filter(name%in%common_pathways$name) %>%
  ###Freshwater Most Common
  filter((pathway.group=='Polyketide sugar unit biosynthesis') | 
           (pathway.group=='Beta-Lactam biosynthesis')|         
           (pathway.group=='Biosynthesis of other secondary metabolites')) %>%
           #(pathway.group=='Lipopolysaccharide metabolism')|
           #(pathway.group=='Photosynthesis')|
           #(pathway.group=='Carbon fixation') | 
           #(pathway.group=='Nitrogen metabolism')) %>%
  #filter(Specific.Location == 'animal'|Specific.Location == 'human'|Specific.Location == 'freshwater'|Specific.Location == 'saltwater'|Specific.Location == 'wastewater') %>%
  filter(Specific.Location == 'animal'|Specific.Location == 'human'|Specific.Location == 'freshwater'|Specific.Location == 'saltwater') %>%
  ###Host-Associated 
  #filter((pathway.group=='Carbon fixation') | 
  #         (pathway.group=='Nitrogen metabolism')|
  #         (pathway.group=='Aromatics degradation')) %>%

  ggplot(aes(x=Genome, y=name, fill= value)) + 
  geom_tile()+
  scale_fill_viridis(option="magma")+
  theme_classic()+
  theme(axis.text.x = element_blank(),
        axis.text.y = element_text(family = "Times New Roman",color='black',size=10))+
  ylab('meatbolic pathways')+
  guides(fill=guide_legend(title="completeness of pathway (%)"))+
  facet_grid(cols=vars(Specific.Location),rows=vars(pathway.group),scales="free",space="free")

subset_heatmap

