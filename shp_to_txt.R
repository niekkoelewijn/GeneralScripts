# Script to transform shapefile to text
# Make saneringscontours readable for fieldworkers
# Niek Koelewijn
# 29-05-2024
# Port of Moerdijk - LPM
# Arcadis

# Install required packages
if(!"tidyverse" %in% rownames(installed.packages())){install.packages("tidyverse")}
if(!"terra" %in% rownames(installed.packages())){install.packages("terra")}
if(!"sf" %in% rownames(installed.packages())){install.packages("sf")}

#load required packages
library(tidyverse)
library(terra)
library(sf)

## Set working directory
#setwd("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - LPM/GIS - 3477737 - LPM Bodem")

# Function to convert shp to txt
shp2txt <- function(name_shape, name_text){
  
  # Determine path to shape and text
  path_shape <- "./02_Data/20240909_JDK_spot_TXT/shapes"
  path_text <- "./02_Data/20240909_JDK_spot_TXT/TXT"
  
  # Select the REDedge and NIR bands of the input raster
  shapefile <- terra::vect(paste0(path_shape, name_shape))
  
  # Prepare txt
  sf_table <- shapefile %>% 
    
    # make SF class
    sf::st_as_sf()
  
  # Prepare txt
  txt_table <- sf_table %>% 
    
    # Create X and Y column
    dplyr::mutate(X = sf::st_coordinates(sf_table)[,1],
                  Y = sf::st_coordinates(sf_table)[,2],
                  ID = row_number(),
                  Name = paste0("JDK haard ", as.character(ID))) %>% 
    
    # Convert to tibble
    tibble::as_tibble() %>% 
    
    # Select suitable columns
    dplyr::select(Name, X, Y)
    
    
  
  # write table to txt
  write_delim(txt_table, delim = ";", file = paste0(path_text, name_text), col_names = F)
}

# Call shp2txt
shp2txt(name_shape = "/JDK_haard_Moerdijkseweg_points.shp", name_text = "/JDK_haard_Moerdijkseweg_points.txt")



