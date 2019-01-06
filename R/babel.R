#' BabelR
#'
#' This package exposes the basic functionality of the
#' openbabel project in R.
#'
#' The ChemmineR package in BioConductor provides more
#' functionality, but it's approach is not my cup of tea.
#'
#' This project will limit its scope to being just a
#' wrapper around the openbabel command line tools.
#'
#' My inital goals are to:
#'   - learn to work with grid graphics
#'     - by combining obabel plots with ggplot2
#'     - by building tools for sorting molecules
#'   - establish conventions to automatically
#'     generate SVG images from sdf files and SMILES strings
#'   - be able to highlight specific atoms or bonds
#'
#' Long term goals include:
#'   - representing molecules as networks with ggraph
#'   - perform substructure searches by a variety of methods
#'   - compute molecular energies
#'   - extract a few molecular descriptors
#'
#' The plan for implementation is to try and build out the
#' conventions to:
#'
#' 1. convert an sdf file into an image and plot it
#' 2. convert an sdf file into a directory of images with
#'    a standard naming convention.
NULL
