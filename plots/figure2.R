##### Load Packages #####
library(tidyr)
library(data.table)
library(dplyr)
library(ggplot2)
library(gridExtra)
library(readxl)
library(stringr)
library(magrittr)
library(ggpubr)
library(ggsignif)
library(rstatix)
library(ggsci)
library(scales)
library(cowplot)
library(Cairo)
library(forcats)
library(tidytext)

##### Load Database counts #####
counts_data <- read.csv(file = 'Database_source_counts.csv')
counts_data<- subset(counts_data, select = -c(X,X.1,X.2,X.3,X.4,X.5,X.6)) 
counts_data <-  na.omit(counts_data)
counts_data<- counts_data[order(counts_data[,3] ),]
colnames(counts_data)[3] ="counts"

##### Order inputs #####
ordered_list <- list(
  # Order for P-Ps #
  "P-P" = c('MGV','GPD','PLSDB','IMGVR'),
  # Order for Plasmids #
  "Plasmid" = c('GPD','MGV','PLSDB','IMGVR'),  
  # Define the order for 'Phage' #
  "Phage" = c('PLSDB', 'GPD', 'MGV','IMGVR'))

counts_data$Database = factor(counts_data$Database, levels=c('MGV','GPD','PLSDB','IMGVR'))
counts_data

##### Create Figure 2A #####
figure2A<- ggplot(counts_data, aes(x=MGE,fill=Database,y=counts)) + 
  geom_bar(position="dodge", stat="identity",color='black',alpha=0.8)+
  theme_classic()+
  theme(axis.text.x = element_text(family = "Helvetica",color='black',size=16),
        axis.text.y = element_text(family = "Helvetica",color='black',size=16),
        axis.title.x = element_text(family = "Helvetica",color='black',size=16),
        axis.title.y = element_text(family = "Helvetica",color='black',size=16),
        legend.text = element_text(family = "Helvetica",size = 16),
        legend.title = element_text(family = "Helvetica",size = 16),
        panel.border=element_blank(),
        legend.position='top')+
  xlab("")+
  ylab("log Number of Classified Elements")+
  scale_fill_lancet()+
  guides(fill=guide_legend(title="Source Database"))+
  scale_y_continuous(trans = log10_trans(),
                     breaks = trans_breaks("log10", function(x) 10^x),
                     labels = trans_format("log10", math_format(10^.x)),
                     expand = c(0, 0))


figure2A

##### Load Hybrid, phage, and plasmid classification results #####
p_p_input <- read.csv(file = 'Total_Final_Final_Hybrids_Updated.fasta_Clustered.fasta.summary.csv')
p_p_input
plasmid_input <- read.csv(file = 'Final_Final_Plasmids.fasta.summary.csv')
plasmid_input
phage_input <- read.csv(file = 'Final_Final_Phages.fasta.summary.csv')

df_hybrid = subset(p_p_input, select = -c(X,Percent.Bacteriophages,Percent.Insertion.sequences,Percent.Integrative.elements,Percent.Plasmids,Percent.Multiple,Amount.of.Unique.ORFs,Multiple,Integrative.elements,Insertion.sequences))
df_hybrid$MGE = 'P-P'
df_hybrid
df_plasmid = subset(plasmid_input, select = -c(X,Percent.Bacteriophages,Percent.Insertion.sequences,Percent.Integrative.elements,Percent.Plasmids,Percent.Multiple,Amount.of.Unique.ORFs,Multiple,Integrative.elements,Insertion.sequences))
df_plasmid$MGE = 'Plasmid'
df_plasmid
df_phage = subset(phage_input, select = -c(X,Percent.Bacteriophages,Percent.Insertion.sequences,Percent.Integrative.elements,Percent.Plasmids,Percent.Multiple,Amount.of.Unique.ORFs,Multiple,Integrative.elements,Insertion.sequences))
df_phage$MGE = 'Phage'
df_phage

df_combine <- rbind(df_hybrid,df_plasmid,df_phage)
df_combine

##### Convert to long format #####
data_long <- gather(df_combine, protein_hits, value, Bacteriophages:Total.Number.of.Hits, factor_key=TRUE)
data_long

##### Create Figure 2B #####
figure2B<-ggboxplot(data_long, x='protein_hits', y='value', fill='MGE',outlier.shape=NA) +
  theme(axis.text.x = element_text(family = "Helvetica",color='black',size=16),
        axis.text.y = element_text(family = "Helvetica",color='black',size=16),
        axis.title.x = element_text(family = "Helvetica",color='black',size=16),
        axis.title.y = element_text(family = "Helvetica",color='black',size=16),
        legend.text = element_text(family = "Helvetica",size = 16),
        legend.title = element_text(family = "Helvetica",size = 16),
        #panel.border=element_blank()
        legend.position='top') +
  scale_fill_npg()+
  ylab("mobileOG protein hits")+
  
  xlab("")+
  guides(fill=guide_legend(title="MGE Class"))+
  scale_y_log10(breaks = trans_breaks("log10",function(x) 10^x),
                labels = trans_format("log10",math_format(10^.x)))+
  scale_x_discrete(labels = c("Total.Number.of.Hits" = "Total Proteins",
                              "Bacteriophages" = "Phage Proteins",
                              "Plasmids" = "Plasmid Proteins"))
figure2B

##### Create Figure 2A and 2B #####
figure_2 <- plot_grid(figure2A,figure2B,ncol=2,rel_widths = c(2/4,2/4),
                      labels = c("A", "B"),label_size=18,label_fontface = "bold")
figure_2
