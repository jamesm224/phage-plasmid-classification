##### Statistical Analysis #####
##### Designed to perform Fischer Exact Test and Kruskal Wallis Test with post Hoc Dunn Test #####

merged_df_2

### Obtain the Mean P-P counts per accessory gene ###
phage_plasmid_subset<- merged_df_2 %>% 
  filter(Specific.Location != 'phage')%>% 
  filter(Specific.Location != 'plasmid')%>%
  #filter(Accessory_gene_type == 'arg')%>% 
  group_by(Accessory_gene_type) %>% 
  # Obtain the Mean Count #
  summarise(total_count=mean(total_count.x)) %>%
  as.data.frame()
phage_plasmid_subset$MGE <- 'P-P'
phage_plasmid_subset

### Obtain the Phage counts per accessory gene ###
phage_subset<- merged_df_2 %>% 
  filter(Specific.Location == 'phage')%>% 
  #filter(Accessory_gene_type == 'arg')%>% 
  group_by(Accessory_gene_type) %>% 
  # Obtain the Mean Count #
  summarise(total_count=mean(total_count.x)) %>%
  as.data.frame()
phage_subset$MGE <- 'phage'
phage_subset

### Obtain the Phage counts per accessory gene ###
plasmid_subset<- merged_df_2 %>% 
  filter(Specific.Location == 'plasmid')%>% 
  #filter(Accessory_gene_type == 'arg')%>% 
  group_by(Accessory_gene_type) %>% 
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

##### Between P-Ps statistical Analysis #####

### Input df ###
#df_unique <- data %>%
#  distinct(Genome, Accessory_gene_type, .keep_all = TRUE)

df_unique

data
### Obtain the Mean P-P counts per accessory gene ###
host_associated <-data %>% 
  filter(Home_location == 'Host-associated')%>% 
  filter(Specific.Location != 'plasmid')%>%
  filter(Specific.Location != 'phage')%>%
  #filter(gene_id == 'CRISPR-CAS')%>% 
  filter(gene_id == 'Nucleotide metabolism')%>% 
  #filter(Accessory_gene_type == 'arg')%>% 
  group_by(gene_id) %>%
  #group_by(Accessory_gene_type) %>% 
  
  # Obtain the Mean Count #
  summarise(present_in_genome = n_distinct(.),.groups = "drop") %>%
  #summarise(total_count=mean(total_count.x),.groups = "drop") %>%
  as.data.frame()
host_associated$MGE <- 'host-associated'
host_associated

aquatic <- data %>% 
  filter(Home_location == 'Aquatic')%>% 
  filter(Specific.Location != 'wastewater')%>%
  filter(Specific.Location != 'other')%>%
  filter(Specific.Location != 'plasmid')%>%
  filter(Specific.Location != 'phage')%>%
  #filter(Accessory_gene_type == 'arg')%>% 
  #group_by(Accessory_gene_type) %>%
  #filter(gene_id == 'CRISPR-CAS')%>% 
  filter(gene_id == 'Nucleotide metabolism')%>% 
  group_by(gene_id) %>%
  # Obtain the Mean Count #
  summarise(present_in_genome = n_distinct(.),.groups = "drop") %>%
  as.data.frame()
aquatic$MGE <- 'aquatic'
aquatic

terrestrial <- data %>% 
  filter(Home_location == 'Terrestrial')%>% 
  filter(Specific.Location != 'plasmid')%>%
  filter(Specific.Location != 'phage')%>%
  #filter(Accessory_gene_type == 'arg')%>%
  #group_by(Accessory_gene_type) %>% 
  filter(gene_id == 'Nucleotide metabolism')%>% 
  group_by(gene_id) %>%
  # Obtain the Mean Count #
  summarise(present_in_genome = n_distinct(.),.groups = "drop") %>%
  as.data.frame()
terrestrial$MGE <- 'terrestrial'
terrestrial

### Combine the phage, plasmid, and P-P dataframes ###
combined_p_p_df <- rbind(host_associated, aquatic, terrestrial)
combined_p_p_df

### Load Contingency Table ###
### Table took host-associated, terrestrial, and aquatic results and made df in excel ###
cont_table <- read_csv(file='fischer_exact_test.csv')
cont_table

contingency_table <- matrix(c(cont_table$Aquatic,cont_table$Host), nrow = 2, byrow = TRUE, dimnames = list(cont_table$Type, colnames(cont_table)[2:3]))

# Print the contingency table
print(contingency_table)

options(expressions = 500000)

# Perform Fisher's exact test
fisher_result <- fisher.test(contingency_table)

print(fisher_result)


# Applying Benjamini-Hochberg Procedure for false discovery rate correction
p_values <- fisher_result$p.value
adjusted_p_values <- p.adjust(p_values, method = "BH")

# Combining results into a data frame
result_df <- data.frame(
  Accessory_gene_type = rownames(contingency_table),
  p_value = p_values,
  adjusted_p_value = adjusted_p_values
)

# Printing the results
print(result_df)
