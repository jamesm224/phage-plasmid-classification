##### Code for visualizing the distribution of different sourced hybrids #####

##### Load Packages and Data #####
library(ggplot2)
library(ggsci)
library(dplyr)

data <- read.csv(file = 'summary_hybrid_taxonomy_updated.csv')
data=data %>% group_by(Home_location,Specific.Location) %>% 
  summarise(taxa_count=n(),.groups = 'drop') %>%
  #filter(taxa_count>=2) %>%
  as.data.frame()
data <- na.omit(data[!(data$Specific.Location == "" | is.na(data$Specific.Location)), ])
data

##### Graphing Code #####
source_location_summary <- ggplot(data, aes(fill=Specific.Location, y=taxa_count, x=Home_location)) + 
  geom_bar(position="stack", stat="identity",alpha=0.8,color='black')+
  #scale_fill_futurama()+
  theme_classic()+
  theme(axis.text.y=element_text(size=16,color='Black'),
        legend.text = element_text(size = 16),
        axis.title.y=element_text(size=16,color='Black'),
        axis.text.x=element_text(angle = 60,hjust=1,size=16,color='Black'),
        legend.direction = "horizontal",
        text = element_text(family="Times New Roman",size=16,color = "Black"),
        legend.position="top")+
  #axis.text.x = element_blank(),
  
  #axis.text.y = element_text(color='black'),
  #legend.position="Top")+
  ylab('Number of Classified P-Ps')+
  #guides()+
  xlab('')+
  guides(fill=guide_legend(title="Source Location"))+
  scale_fill_manual(breaks=c('freshwater', 'saltwater', 'wastewater','animal','fungi','human','plant','human-engineered facilities','sediment','soil','other','Unclassified'), 
                    values = alpha(c("#a3cef1","#6096ba","#274c77",
                                              "#ff6166","#ff374e","#ffc052","#ff6929",
                                              "#80ed99","#57cc99","#6a994e",
                                              "#e7ecef","#D3D3D3"
                    )))+
#scale_fill_discrete()
scale_y_continuous(expand = c(0, 0))
source_location_summary

temp_graph <- source_location_summary + coord_flip()

temp_graph

