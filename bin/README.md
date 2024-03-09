# File Descriptions #
Lists the descriptions of each script

# 1. Running Classifier Scripts #

mobileOG-pl_pipeline_run.sh - processing
create_classifier_inputs.py - converts mobileOG output to RF classifier input
creating_RF_classifier.py - creates the RF classifier using testing/training data
RF_classification.py - classifies genomes using the RF classifier

# 2. Optimization and Benchmarking Scripts #

optimization_experiment.sh - optimization script for pipeline
co_localization_optimization.py - optimization script for co-localization experiment
co_localization_experiment.sh - script to run co-localization experiment
co_localization_experiment.py - script to run co-localization experiment
generate_purity.py - obtains the purity of each mobileOG cluster


# 3. Downstream Analysis and Accessory Gene Scripts #

cd_hit.sh - clustering script
making_gbks.sh - create gbk files for prokka
making_gffs.sh - make gff files
genome_size_determining.py - obtains genome size for genomes
card_output.py - data wrangling for the CARD output
microbeannotator.sh - run microbeannatator
padloc_analysis.py - run padloc script
pfam_analysis.py - script for pfams
run_clinker.sh - run clinker on genomes

