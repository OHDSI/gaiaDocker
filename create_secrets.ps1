#!/usr/bin/env pwsh

# create empty password files for the gaiaDocker environment. 
# NOTE: this will not overwrite existing secrets

if (-not (Test-Path ".\secrets\github_pat")) {
  New-Item -Path ".\secrets\github_pat" -ItemType File
}
if (-not (Test-Path ".\secrets\gaia\AIRNOW_API_KEY")) {
  New-Item -Path ".\secrets\gaia\AIRNOW_API_KEY" -ItemType File
}
if (-not (Test-Path ".\secrets\gaia\CDC_APP_TOKEN")) {
  New-Item -Path ".\secrets\gaia\CDC_APP_TOKEN" -ItemType File
}
if (-not (Test-Path ".\secrets\gaia\CENSUS_API_KEY")) {
  New-Item -Path ".\secrets\gaia\CENSUS_API_KEY" -ItemType File
}
if (-not (Test-Path ".\secrets\gaia\COPERNICUS_KEY")) {
  New-Item -Path ".\secrets\gaia\COPERNICUS_KEY" -ItemType File
}
if (-not (Test-Path ".\secrets\gaia\USGS_PASSWORD")) {
  New-Item -Path ".\secrets\gaia\USGS_PASSWORD" -ItemType File
}
if (-not (Test-Path ".\secrets\gaia\USGS_USER")) {
  New-Item -Path ".\secrets\gaia\USGS_USER" -ItemType File
}

Write-Host "all secrets checked and created as empty if none found"Item_type