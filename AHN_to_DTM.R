# Script to create DTM's from LAZ files of AHN
# Make comparisson of AHN1 and AHN5 
# Niek Koelewijn
# 16-01-2025
# Port of Moerdijk - Truckweg Tradepark
# Arcadis


## Load required packages

# Function to install and load packages
CheckPackages <- function(packagelist){
  for (package in packagelist){
    if(!require(package, character.only = TRUE)){
      install.packages(package, character.only = TRUE)
      require(package, character.only = TRUE)
    }
    library(package, character.only = TRUE)
  }
}

# Call ChackPackages
CheckPackages(c("lidR", "sf", "dplyr", "ggmap", "sp", "rgdal", "future", "timeDate", 
                "terra", "rayshader", "tictoc", "colorRamps", "MBA", "magick",
                "viridis", "tidyverse", "VLSM", "exactextractr", "mapview",
                "randomForest", "caret", "car", "ggsignif", "ggpubr", "FSA",
                "Hmisc", "sjstats", "survey", "WeightIt", "ggstatsplot",
                "ggrepel"))

#Set working directory
setwd("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark")



### Create LAS catalog for both AHN versions


## AHN1

# Create AHN1 catalog
AHN1_catalog <- lidR::readLAScatalog("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/01_SourceData/43HN2_18_AHN1.LAZ")

# # Visualize AHN3 catalog and study area
# plot(AHN3_catalog, chunk = T)
# plot(st_geometry(study_area_speulderbos), add = T)


## AHN5

# Create AHN4 catalog
AHN5_catalog <- lidR::readLAScatalog("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/01_SourceData/43HN2_18_AHN5.LAZ")



### Create DTM


## AHN1

# TIN
dtm_AHN1_tin <- rasterize_terrain(AHN1_catalog, res = 1, algorithm = tin())
#dtm_AHN1_tin <- terra::rast("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/dtm_AHN1.tif")


## AHN5

# TIN
dtm_AHN5_tin <- rasterize_terrain(AHN5_catalog, res = 1, algorithm = tin())
#dtm_AHN5_tin <- terra::rast("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/dtm_AHN5.tif")


## Visualize DTM's of different algorithmns


# 2D
plot(dtm_AHN1_tin, main="DTM AHN1 TIN", col=height.colors(500))
plot(dtm_AHN5_tin, main="DTM AHN5 TIN", col=height.colors(500))

# 3D
plot_dtm3d(dtm_AHN1_tin, bg = "white") 
plot_dtm3d(dtm_AHN5_tin, bg = "white") 


## Compare difference in DTM

# Get difference in DTM
div_dtm_tin <- dtm_AHN5_tin - dtm_AHN1_tin

# Visualize difference in DTM
plot(div_dtm_tin, main = "Difference in DTM (TIN) between AHN versions", col = height.colors(500))


# Write DTM to file
path <- "C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/"
terra::writeRaster(dtm_AHN1_tin, paste0(path, "dtm_AHN1.tif"), overwrite = T)
terra::writeRaster(dtm_AHN5_tin, paste0(path, "dtm_AHN5.tif"), overwrite = T)
terra::writeRaster(div_dtm_tin, paste0(path, "dtm_dif_AHN1_AH5.tif"), overwrite = T)


## Read default 5m into R from AHN website

# Read AHN default DTMs
dtm_AHN1_5m <- terra::rast("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/43hn2_AHN1_DTM_5m.tif")
dtm_AHN5_5m <- terra::rast("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/43HN2_AHN5_DTM_5m.tiff")

# Calculate difference in DTM
div_dtm_5m <- dtm_AHN5_5m - dtm_AHN1_5m
terra::writeRaster(div_dtm_5m, paste0(path, "dtm_dif_5m.tif"), overwrite = T)

# Plot
plot(dtm_AHN1_5m, main="DTM AHN1 TIN", col=height.colors(500))
plot(dtm_AHN5_5m, main="DTM AHN5 TIN", col=height.colors(500))
plot(div_dtm_5m, main="DTM AHN1 TIN", col=height.colors(500))


## AHN3

# Create AHN3 catalog
AHN3_catalog <- lidR::readLAScatalog("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/01_SourceData/AHN3 LPM")

## AHN5

# Create AHN4 catalog
AHN5_catalog <- lidR::readLAScatalog("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/01_SourceData/AHN5 LPM")



### Create DTM for LPM


## AHN3

# TIN
dtm_AHN3_LPM <- rasterize_terrain(AHN3_catalog, res = 1, algorithm = tin())
#dtm_AHN3_LPM <- terra::rast("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/Hoogtemodellen/LPM/dtm_AHN3_LPM.tif")

## AHN5

# TIN
dtm_AHN5_LPM <- rasterize_terrain(AHN5_catalog, res = 1, algorithm = tin())
#dtm_AHN5_LPM <- terra::rast("C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/Hoogtemodellen/LPM/dtm_AHN5_LPM.tif")


# Write DTM to file
path <- "C:/Users/koelewin5099/OneDrive - ARCADIS/GIS/HBM - Truckweg Tradepark/02_Data/Hoogtemodellen/LPM/"
terra::writeRaster(dtm_AHN5_LPM, paste0(path, "dtm_AHN5_LPM.tif"), overwrite = T)


## Compare difference in DTM

# Get difference in DTM
dif_dtm_LPM <- dtm_AHN5_LPM - dtm_AHN3_LPM

# Visualize difference in DTM
plot(dif_dtm_LPM, main = "Difference in DTM (TIN) between AHN versions", col = height.colors(500))

# Write DTM to file
terra::writeRaster(dif_dtm_LPM, paste0(path, "dtm_dif_AHN3_AH5.tif"), overwrite = T)
