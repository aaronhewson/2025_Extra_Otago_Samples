# Rename sample files, using an Excel sheet with the old/new names for each file.
# First to rename are .CEL files received from genotyping provider, which have the genotyping well added to their names. These are renamed to shorter Sample IDs.
# Second to rename are files produced by Axiom CNV Tool, which outputs ".nexus.cnv.txt" files. These are renamed to ".txt" as file extension.

# Load Packages -----------------------------------------------------------

#Loading packages
library(readxl)
library(fs)

# Rename .CEL Sample Files Prior to Genotyping ----------------------------

# Path to the Excel with renaming columns, and folder with .CEL genotype files to be renamed
excel_path <- "Inputs/Rename_Files.xlsx"
file_dir <- "C:/Users/curly/Desktop/Apple Genotyping/Inputs/Genotype Files/Nov_2025_Sampling/All_Files_BSI_Otago"

# Read Excel file
rename_df <- read_excel(excel_path)

# Loop through each row and rename the genotyping files
for(i in seq_len(nrow(rename_df))){ 
  old_name <- rename_df$Gen_Old[i] 
  new_name <- rename_df$Gen_New[i] 
  
  old_path <- file.path(file_dir, old_name)
  new_path <- file.path(file_dir, new_name)
  
  if (file_exists(old_path)) {
    file_move(old_path, new_path)
    message(paste("Renamed:", old_name, "->", new_name))
  } else {
    warning(paste("File not found:", old_name))
  }
}


# Rename CNV Files from Axiom ---------------------------------------------

# Path to the Excel with renaming columns, and folder with .txt CNV files to be renamed
excel_path <- "Inputs/Rename_Files.xlsx"
file_dir <- "C:/Users/curly/Desktop/Apple Genotyping/Methods/2025_Extra_Otago_Samples/Inputs/CNV_Files"

# Read Excel file
rename_df <- read_excel(excel_path)

# Loop through each row and rename the CNV files
for(i in seq_len(nrow(rename_df))){ 
  old_name <- rename_df$CNVOld[i] 
  new_name <- rename_df$CNVNew[i] 
  
  old_path <- file.path(file_dir, old_name)
  new_path <- file.path(file_dir, new_name)
  
  if (file_exists(old_path)) {
    file_move(old_path, new_path)
    message(paste("Renamed:", old_name, "->", new_name))
  } else {
    warning(paste("File not found:", old_name))
  }
}

