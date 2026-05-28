# Duplicate analysis of samples, using PLINK.
# Genotyping results are exported from Axiom Analysis Suite in PLINK .ped/.map format. 
# Only a filtered list of quality SNPs common across 20K/50K/480K arrays are exported (based off list from Nicholas Howard)
# Combined with genotype data from all other datasets (international + NZ)

# Load Packages -----------------------------------------------------------

#Load packages
library(tibble)
library(igraph)

library(dplyr)
library(tidyr)


# Set Working Directory ---------------------------------------------------

#Set wd
setwd("C:/Users/curly/Desktop/Apple Genotyping/Methods/2025_Extra_Otago_Samples/Inputs/Filtered_Genotypes")

# Run PLINK Duplicate Analysis --------------------------------------------

#clear workspace
rm(list=ls())

#Run PLINK
system("plink --file Genotypes_DupeCheck --missing-genotype 0 --genome full")

# Load and Save PLINK .genome File ----------------------------------------

#Read genome file
genome <- read.table("plink.genome", header = TRUE, sep = "", stringsAsFactors = FALSE)
write.table(genome, "C:/Users/curly/Desktop/Apple Genotyping/Results/2025_Extra_Otago_Samples/Duplicates/PLINK_Genome.txt", sep = "\t", row.names = FALSE, quote = FALSE)

# Grouping Duplicate IDs --------------------------------------------------

#Filter for PI_HAT >0.97 (duplicate threshold)
genome <- genome[!(genome$PI_HAT < 0.97), ]

#Save .txt of duplicate pairs
write.table(genome, "C:/Users/curly/Desktop/Apple Genotyping/Results/2025_Extra_Otago_Samples/Duplicates/Duplicate_Pairs.txt", sep = "\t", row.names = FALSE, quote = FALSE)

#Keep only IDs
genome <- subset(genome, select = c("IID1","IID2"))

#Group duplicates with igraph
graph <- graph_from_data_frame(genome, directed = FALSE)
components <- components(graph)

#Sort groupings by number of duplicates
group_sizes <- table(components$membership)
sorted_group_ids <- order(group_sizes)
new_ids <- match(components$membership, sorted_group_ids)
V(graph)$group <- new_ids
grouped_samples <- split(names(components$membership), new_ids)

#Pad group with length less than max length with NA's
max_len <- max(sapply(grouped_samples, length))
padded_list <- lapply(grouped_samples, function(x) {c(x, rep(" ", max_len - length(x)))})

#Write groupings to a dataframe
dd <- as.data.frame(do.call(rbind, padded_list))

#Add a number for each group
dd <- cbind(Group = seq_len(nrow(dd)), dd)

# Add the number of duplicates in each grouping
sample_counts <- rowSums(dd[, -1] != " ")
dd <- add_column(dd, SampleCount = sample_counts, .after = "Group")

#Rename columns
colnames(dd) <- c("Group", "SampleCount", "ID1","ID2","ID3","ID4","ID5","ID6","ID7","ID8","ID9")

#Save .csv of duplicate groupings
write.csv(dd, "C:/Users/curly/Desktop/Apple Genotyping/Results/2025_Extra_Otago_Samples/Duplicates/Grouped_Duplicates.csv", row.names = FALSE)


