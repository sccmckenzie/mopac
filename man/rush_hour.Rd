% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{rush_hour}
\alias{rush_hour}
\title{Sample of vehicles collected from Loop 1 "Mopac" in Austin, Texas.}
\format{
A tibble with 962 rows and 7 variables:
\describe{
  \item{day}{day of the week when observations were recorded}
  \item{time}{observation timestamp}
  \item{commercial}{indicates whether vehicle is used for commercial purposes}
  \item{color}{vehicle color}
  \item{type}{vehicle type}
  \item{make}{vehicle make}
  \item{model}{vehicle model}
}
}
\source{
Real observations collected from northbound Mopac at Far West Blvd.
}
\usage{
rush_hour
}
\description{
Observations sampled in 2.5 minute intervals throughout week of 17 May 2020. Note that although intervals fall within normal "rush hour" timeframe, traffic density is lighter than normal due to COVID.
}
\keyword{datasets}
