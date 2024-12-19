#!/usr/bin/env Rscript
library(exifr)
library(ggplot2)

# Function: Calculate adjusted focal length
process_images <- function(directory) {
  # Get all jpg files
  files <- list.files(directory, pattern = "\\.jpg$", recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
  
  if (length(files) == 0) {
    message("No valid JPG files found")
    return(NULL)
  }
  
  # Extract EXIF data
  exif_data <- read_exif(files)
  
  # Filter relevant data
  if (!("FocalLength" %in% colnames(exif_data)) || 
      !("ImageWidth" %in% colnames(exif_data)) || 
      !("ImageHeight" %in% colnames(exif_data))) {
    message("Incomplete metadata; unable to extract focal length or dimensions")
    return(NULL)
  }
  
  # Calculate total pixels and adjusted focal length
  exif_data <- exif_data[!is.na(exif_data$FocalLength) & 
                           !is.na(exif_data$ImageWidth) & 
                           !is.na(exif_data$ImageHeight), ]
  exif_data$TotalPixels <- exif_data$ImageWidth * exif_data$ImageHeight
  exif_data$AdjustedFocalLength <- as.integer( exif_data$FocalLength/(exif_data$TotalPixels / 45441024) )
  
  return(exif_data$AdjustedFocalLength)
}

# Function: Plot histogram
plot_histogram <- function(data, output_file = "histogram.png") {
  if (is.null(data) || length(data) == 0) {
    message("No data available for plotting")
    return()
  }
  
  # Plot histogram
  p <- ggplot(data = data.frame(FocalLength = data), aes(x = FocalLength)) +
    geom_histogram(bins = 20, fill = "blue", color = "black", alpha = 0.7) +
    labs(title = "Adjusted Focal Length Distribution", x = "Adjusted Focal Length", y = "Frequency") +
    theme_minimal() +
    scale_x_continuous(breaks = c(10, 16, 24, 35, 50, 85, 105, 120, 200)) # Custom x-axis ticks
  
  # Save histogram with specified dimensions (width = 7, height = 5)
  ggsave(output_file, plot = p, width = 7, height = 5, units = "in")
  message("Histogram saved as ", output_file)
}

# Main program
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) {
  stop("Please provide a directory path as an argument. Example: Rscript process_images.R /path/to/directory")
}

directory <- args[1]
if (!dir.exists(directory)) {
  stop("Invalid directory path: ", directory)
}

data <- process_images(directory)

if (!is.null(data)) {
  plot_histogram(data)
} else {
  message("Processing complete, but no sufficient data for generating a histogram")
}