##### Load Packages #####
library(ggplot2)
library(dplyr)
library(tidyr)
library(RColorBrewer)
library(cowplot)
library(viridis)
library(ggsci)
library(ggpubr)
library(rstatix)
library(purrr)
library(tidyverse)
library(pheatmap)
library(reshape2)
library(vegan)
library(scales) 
library(ggfortify)
library(grDevices)
library(Cairo)

##### Load Input Data #####
data <- read.csv(file = 'crispr_hybrid_data.csv')
counts <- read.csv(file='total_hybrid_counts.csv')

##### Group data by unique genomes #####
grouped_outputs<- data %>% distinct(Genome,system, .keep_all = TRUE)
grouped_outputs

##### Obtain total defense system counts per genome #####
system_counts<- grouped_outputs %>% 
  group_by(Home_location,Specific.Location,system) %>% 
  summarise(total_count=n(), .groups = "drop") %>%
  as.data.frame()
system_counts$Specific.Location <- factor(system_counts$Specific.Location, 
                                   levels = c("freshwater", "saltwater", "wastewater",
                                              "fungi", "plant","animal","human",
                                              "soil", "sediment", "human facilities","other",
                                              "unclassified P-P","plasmid","phage"))
system_counts$Home_location <- factor(system_counts$Home_location, 
                               levels = c("Aquatic","Host-associated", "Terrestrial", "Other"))
system_counts <- system_counts[-1,]
system_counts

##### Obtain total counts from each source location #####
total_counts<- counts %>% 
  group_by(Specific.Location) %>% 
  summarise(raw_counts=n(), .groups = "drop") %>%
  as.data.frame()
total_counts

##### Calculate the frequency of systems per genome ##### 
final_crispr <- merge(system_counts,total_counts,by='Specific.Location')
final_crispr$freq <- final_crispr$total_count / final_crispr$raw_counts *100
final_crispr

##### Graph 6A #####
final_system_counts <- ggplot(final_crispr, aes(x = system, y = freq,fill=Specific.Location))+
  geom_bar( stat="identity",color='black')+
  theme_classic()+
  theme(axis.text.y=element_text(size=16,color='Black'),
        legend.text = element_text(size = 16),
        axis.title.y=element_text(size=16,color='Black'),
        axis.text.x=element_text(size=16,color='Black'),
        text = element_text(family="Times New Roman",size=16,color = "Black"))+
  ylab('relative abundance of defense systems (%)')+
  xlab('')+
  guides(fill=guide_legend(title="Environment"))+
  scale_fill_manual(breaks=c('freshwater', 'saltwater', 'wastewater','animal','fungi','human','plant','human facilities','sediment','soil','other','unclassified P-P'), 
                    values = alpha(c("#a3cef1","#6096ba","#274c77",
                                     "#ff6166","#ff374e","#ffc052","#ff6929",
                                     "#80ed99","#57cc99","#6a994e",
                                     "#e7ecef","#D3D3D3"
                    )))+
  scale_y_continuous(expand = c(0, 0))
final_system_counts

##### Obtain the CRISPR gene counts #####
crispr<- data %>% 
  filter(system == 'CRISPR-Cas')%>% 
  group_by(system,Major.Class,Subset) %>% 
  summarise(total_count=n(), .groups = "drop") %>%
  as.data.frame()
crispr

##### Plot CRISPR genes #####
crispr_plot <- ggplot(crispr, aes(x = Subset, y = Major.Class)) +
  geom_point(size = crispr$total_count/240*80,color='#94A1EF') +
  geom_text(aes(label=total_count),vjust=-1.5,family="Times New Roman",size=8)+
  ylab('CRISPR Types')+
  labs( x = "Subtypes")+
  theme_light()+
  theme(axis.text.y=element_text(size=16,color='Black'),
        axis.title.x=element_text(size=16,color='Black'),
        axis.text.x=element_text(size=16,color='Black'),
        text = element_text(family="Times New Roman",size=16,color = "Black"))
crispr_plot

##### Obtain the anti-CRISPR gene counts #####
anti_crispr<- data %>% 
  filter(system == 'anti-CRISPR')%>% 
  group_by(system,Major.Class,Subset) %>% 
  summarise(total_count=n(), .groups = "drop") %>%
  as.data.frame()
anti_crispr

##### Plot anti-CRISPR genes #####
anti_crispr_plot <- ggplot(anti_crispr, aes(x = Subset, y = Major.Class)) +
  geom_point(size = anti_crispr$total_count/239*40,color='#FF6961') +
  geom_text(aes(label=total_count),vjust=-3.3,family="Times New Roman",size=8)+
  ylab('Anti-CRISPR Types')+
  labs( x = "Subtypes")+
  theme_light()+
  theme(axis.text.y=element_text(size=16,color='Black'),
        axis.title.x=element_text(size=16,color='Black'),
        axis.text.x=element_text(size=16,color='Black'),
        text = element_text(family="Times New Roman",size=16,color = "Black"))
anti_crispr_plot

##### Plot Figure 6 #####
plot1 <- plot_grid(crispr_plot,anti_crispr_plot,nrow=2,
                   labels = c("B", "C"))
plot1

figure_6 <- plot_grid(final_system_counts,plot1,ncol=2,rel_widths = c(2/5,3/5),
                   labels = c("A", ""))
figure_6


##### Save and Export Figure #####
Cairo(file = "figure6.svg", type = "svg", width = 100, height = 70, units = "in", dpi = 400)
print(figure_6)  # 'final_graph' is the ggplot object
dev.off()
