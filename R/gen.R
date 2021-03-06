#' Various helper functions that GENerate derived variables
#'


#  =================================
#  = Positive pressure ventilation =
#  =================================
#' @examples
#' # gen_ppv(ddata, time, id, Total_Resp_Rate_Ventil)

#' gen_ppv makes a logical vector if positive pressure ventilated
#' @export
gen_ppv <- function(dt, t_=time, id_= id, rrate_ppv_) {
    # - [ ] TODO(2016-05-20): add in airway and ventilated fields

    # Non-standard evaluation
    pars <- as.list(match.call()[-1])

    id_ <- as.character(pars$id_)
    t_ <- as.character(pars$t_)
    rrate_ppv_ <- as.character(pars$rrate_ppv_)

    # need ccdata wide
    # remember that data.table will copy as reference
    # need a unique id (site+episode_id)
    # plus time
    # plus a series of columns or logical expression that can be used to define PPV

    setkeyv(dt, c(id_, t_))
    if ("ppv" %chin% names(dt)) dt[, `:=`(ppv =NULL)]
    dt[, `:=`(
        ppv = get(rrate_ppv_) > 0
        ),
        roll=+Inf, # roll forwards without limit
        rollends=c(FALSE, TRUE) # roll forwards from the last value, but not back from first
                 ]
}

#  ==========================
#  = Mean arterial pressure =
#  ==========================
# - [ ] FIXME(2016-05-20): wrap these two functions into one (gen_map and choose_first_nonmissing)

#' Generate MAP from blood pressure
#' gen_map derives MAP
#' @export
gen_map <- function(bps, bpd) {
    return(bpd + (bps-bpd)/3)
}

#' Choose first non-missing
#' @export
choose_first_nonmissing <- function(colvalues) {
    library(purrr)
    reduce(colvalues, function(x,y) ifelse(!is.na(x), x, y))
}


