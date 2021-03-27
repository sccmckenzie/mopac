#' Sample of vehicles collected from Loop 1 "Mopac" in Austin, Texas.
#'
#' Observations sampled in 2.5 minute intervals throughout week of 17 May 2020. Note that although intervals fall within normal "rush hour" timeframe, traffic density is lighter than normal due to COVID.
#'
#' @format A tibble with 962 rows and 7 variables:
#' \describe{
#'   \item{day}{day of the week when observations were recorded}
#'   \item{time}{observation timestamp}
#'   \item{commercial}{indicates whether vehicle is used for commercial purposes}
#'   \item{color}{vehicle color}
#'   \item{type}{vehicle type}
#'   \item{make}{vehicle make}
#'   \item{model}{vehicle model}
#' }
#'
#' @source Real observations collected from northbound Mopac at Far West Blvd.
"rush_hour"

#' Exit information for Mopac.
#'
#' Accurate as of 2021-03-26. Provides basic details for all exits along Loop 1 "Mopac" in Austin, Texas. Exits are unnumbered.
#'
#' @format A tibble with 32 rows and 4 variables:
#' \describe{
#'   \item{mi}{distance from Loop 1 southern terminus, in miles}
#'   \item{km}{distance from Loop 1 southern terminus, in kilometers}
#'   \item{exit}{main road accessed by exit}
#'   \item{notes}{additional information}
#' }
#' @source Scraped from \url{https://en.wikipedia.org/wiki/Texas_State_Highway_Loop_1}
"exits"

#' Mopac Express Lane Records
#'
#' Simulated observations of vehicles entering Mopac express lane at RM 2222 / Far West Blvd. Vehicle make/model/color frequencies are based on actual data from rush_hour. Traffic density inferred from ad hoc sampling and City of Austin Traffic Counts.
#'
#' @format A tibble with 13032 rows and 6 variables:
#' \describe{
#'   \item{direction}{\strong{north}: Far West entry point heading to Parmer, \strong{south}: RM 2222 heading to Cesar Chavez}
#'   \item{time}{time of day}
#'   \item{plate}{vehicle license plate}
#'   \item{make}{vehicle make}
#'   \item{model}{vehicle model}
#'   \item{color}{vehicle color}
#' }
#' @source To see how this dataset was generated, visit \url{https://sccm.io/post/mopac-dataset/}
#' @source For City of Austin Traffic Counts, visit \url{https://data.austintexas.gov/Transportation-and-Mobility/Camera-Traffic-Counts/sh59-i6y9}
"express"


#' Mopac Express Lane Rates
#'
#' Express Lane Rates for Loop 1 "Mopac" in Austin, Texas. Rates correspond to RM 2222 / Far West entry points with pre-COVID weekday traffic. Recommend loading \href{https://readr.tidyverse.org/}{readr} package so that \code{time} displays correctly as \strong{hms}.
#'
#' @format A tibble with 25 rows and 3 variables:
#' \describe{
#'   \item{direction}{\strong{north}: Far West entry point heading to Parmer, \strong{south}: RM 2222 heading to Cesar Chavez}
#'   \item{time}{time of day}
#'   \item{rate}{TxTag rate in USD}
#' }
#' @source {Rates obtained from Central Texas Regional Mobility Authority.} \url{https://www.mobilityauthority.com/pay-your-toll/rates}
"rates"
