# This script plots histograms of the B Allele Frequency (BAF) values of SNPs for genotyped samples.
# A BAF histogram is plotted for each sample, which are saved separately as PNG files and also compiled into a PDF.
# The BAF histograms are to interpret ploidy of samples, as per Chagné et al. 2015 (https://doi.org/10.1007/s11295-015-0920-8)

# Load Packages -----------------------------------------------------------

library(graphics)


# Set Input/Output Paths --------------------------------------------------
input_dir <-"C:/Users/curly/Desktop/Apple Genotyping/Methods/2025_Extra_Otago_Samples/Inputs/CNV_Files"
output_dir <-"C:/Users/curly/Desktop/Apple Genotyping/Results/2025_Extra_Otago_Samples/Ploidy/BAF_Plots"
output_pdf <-"C:/Users/curly/Desktop/Apple Genotyping/Results/2025_Extra_Otago_Samples/Ploidy/BAF_Plots/All_BAF_Plots.pdf"


# List Sample Files -------------------------------------------------------

#List all files (must be .txt)
files <- list.files(input_dir, pattern = ".txt", full.names = TRUE)


# Plot and Save BAF Histograms --------------------------------------------

#Set PDF parameters - output path, dimensions, histograms per page.
pdf(file = output_pdf, width = 6, height = 8)
par(mfrow = c(4,2))

#Setting histogram count to zero
plot_count <- 0

#Plot all histograms
for (file in  files){
  #Reading in data
  data <- read.table(file, header = TRUE,row.names = NULL)
  BAF <- data$BAF
  
  #Removing file extension from filename
  file_base <- tools::file_path_sans_ext(basename(file))
  
  #Plotting histogram and exporting as PNG
  png(filename = file.path(output_dir, paste0(file_base,".png")), width = 1000, height = 600)
  par(mar = c(5,5,4,2))
  hist(BAF, main = paste(file_base), xlab = "B Allele Frequency", ylab = "Count", col = "firebrick1", border = "black", cex.main = 2.8, cex.lab = 2, cex.axis = 1.5)
  
  dev.off()
  
  #Plotting histogram for PDF
  par(mar = c(3,4,2,4))
  hist(BAF, main = paste(file_base), xlab = "B Allele Frequency", ylab = "Count", col = "firebrick1", border = "black")
  
  #Counting histograms plotted for PDF  
  plot_count <- plot_count + 1
  
  #Making new page on PDF for every 8 histograms
  if (plot_count %% 8 == 0) {
    par(mfrow = c(4,2))
  }
}
dev.off()
