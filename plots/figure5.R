##### Scripts for figure 5A and 5B. 5C was made using Proksee #####
##### Load Packages and Input Files #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(cowplot)
library(viridis)
library(ggpubr)
library(rstatix)
library(tidyverse)
library(Cairo)

####Source Location Frequency Graph ####
source_meta <- read.csv(file = 'arg_total_counts.csv')

##### Order the variables for the graph #####
source_meta$Source_location <- factor(source_meta$Source_location, 
                                      levels = c("Host-associated", "Unclassified","Aquatic", "Terrestrial"))
source_meta
total_env_distribution=source_meta %>% group_by(Home_location) %>% 
  summarise(total_counts=n(),.groups = 'drop') %>%
  as.data.frame()
total_env_distribution

merged_metadata <- merge(source_meta, total_env_distribution, by = "Home_location",how='left_join')
merged_metadata

####Source Location Frequency Graph ####
args <- read.csv(file = '/Users/jamesmullet/phage_plasmid_args.csv')
args$Genome <- sapply(strsplit(args$Genome, "\\."), `[`, 1)
args

##### Order the variables for the graph #####
merged_df <- merge(args, merged_metadata, by = "Genome",how='outer')
merged_df

# Remove duplicates based on col1 and col2
merged_df_distinct <- merged_df %>% distinct(Genome, Home_location, .keep_all = TRUE)
merged_df_distinct

arg_distribution_df=merged_df_distinct %>% group_by(Home_location,total_counts) %>% 
  summarise(arg_counts=n(),.groups = 'drop') %>%
  as.data.frame()
arg_distribution_df$percent_abundance <- arg_distribution_df$arg_counts / arg_distribution_df$total_counts*100

##### Order the variables for the graph #####
arg_distribution_df$Home_location <- factor(arg_distribution_df$Home_location, 
                                      levels = c("Host-associated", "Unclassified","Aquatic", "Terrestrial"))

##### Graph the distribution of ARGs by Location #####
source_location_summary <- ggplot(arg_distribution_df, aes(fill=Home_location, y=percent_abundance,x=Home_location)) + 
  geom_bar(position="dodge", stat="identity",color='black')+
  theme_classic()+
  theme(axis.text.x=element_blank(),
        legend.text = element_text(family = "Helvetica",size = 12),
        legend.title = element_text(family = "Helvetica",size = 12),
        axis.title.x=element_text(size=15,color='Black'),
        axis.text.y=element_text(hjust=1,size=15,color='Black'),
        legend.position='top',
        text = element_text(family="Helvetica",size=15,color = "Black"),)+
  ylab('Fraction (%)')+
  xlab('')+
  guides(fill=guide_legend(title="Source Location"))+
  # Custom Colors used in graph #
  scale_fill_manual(breaks=c('Aquatic', 'Host-associated', 'Terrestrial','Unclassified'), 
                    values = alpha(c("#a3cef1",
                                     "#ff6166",
                                     "#80ed99",
                                     "#D3D3D3")))+
  scale_y_continuous(limits = c(0,6),expand = c(0, 0))+
  scale_x_discrete(expand = c(0, 0.5))
source_location_summary

##### Bar Chart of ARG Gene Distribution ####

##### Load Dataframe #####
arg_data <- read.csv(file = 'Hybrid_ARG_Source_Out.csv')
arg_data

##### Remove genome columns #####
arg_subset<- subset(arg_data, select = -c(Genome))
arg_subset

##### Obtain the total counts of ARGs per source location #####
arg_counts <- arg_subset %>% group_by(ARG,Home_location,Specific.Location,Major_class) %>% 
  summarise(total_count=n(),.groups = 'drop') %>%
  as.data.frame()
arg_counts 

##### Obtain all possible combinations of ARGs and source locations (equal zero values later)
all_args <- arg_counts %>% expand(ARG, Specific.Location,Major_class) %>%
  as.data.frame() #%>% 
#filter(!grepl('Other', Specific.Location))
all_args %>% dplyr::anti_join(arg_counts)%>%
  as.data.frame()
all_args

arg_merge<- arg_counts %>% dplyr::right_join(all_args)%>%
  as.data.frame()
arg_merge[is.na(arg_merge)] = 0
arg_merge

##### Filter out the rare ARGs #####
high_count=arg_merge %>% group_by(ARG) %>% 
  summarise(total_count=sum(total_count)) %>%
  filter(total_count>= 12) %>%
  as.data.frame()
high_count

##### Calculate Genome Counts by location #####
genome_count<- subset(arg_data, select = -c(ARG)) %>% 
  group_by(Home_location,Specific.Location) %>% 
  summarise(total_count=n()) %>%
  as.data.frame()
genome_count

##### Calculate Frequency of ARGs from each sample #####
merged_out <- arg_merge %>% inner_join(genome_count, 
                                 by=c('Home_location','Specific.Location'))

merged_out$freq <- merged_out$total_count.x / merged_out$total_count.y *100
merged_out


##### Plot ARG counts by Source Location #####
bar1 <- merged_out%>%filter(ARG%in%high_count$ARG) %>%
  ggplot(aes(fill=Specific.Location,
             y=freq, x=reorder(ARG, total_count.y))) +
  geom_bar(position="stack", stat="identity",color='black')+
  theme_classic()+
  ylab('proportion of AMR genes (%)')+
  scale_fill_brewer(palette = "Set2")+
  facet_grid(rows=vars(Major_class),scales="free",space="free")+
  theme(text = element_text(family="Helvetica",size=15,color = "black"),
    axis.text.x = element_text(color='black',size=15),
    axis.title.y=element_blank(),
    axis.text.y = element_text(color='black',size=15),
    legend.text = element_text(family = "Helvetica",size = 12),
    legend.title = element_text(family = "Helvetica",size = 12),
    legend.position = "top",
    legend.justification = c("right"),
    panel.border=element_blank(),
    strip.text.y = element_text(size = 14,angle=0))+
  guides(fill=guide_legend(title="Source Location"))+
  scale_y_continuous(limits = c(0,60), expand = c(0, 0))

bar1

##### Flip axis of plot #####
bar2 <- bar1 +coord_flip()
bar2

##### Combine figure 5A and 5B together #####
figure_5 <- plot_grid(source_location_summary,bar2,
                   labels = c("A","B"),rel_widths = c(2/5,3/5),align = "h", axis = "bt")
figure_5

##### Optional Saving file step #####
#Cairo(file = "figure5.svg", type = "svg", width = 55.5, height =25, units = "in", dpi = 200)
#print(figure_5)  # 'final_graph' is the ggplot object
#dev.off()
