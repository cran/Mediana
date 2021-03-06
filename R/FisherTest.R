######################################################################################################################

# Function: FisherTest .
# Argument: Data set and parameter (call type).
# Description: Computes one-sided p-value based on two-sample Fisher exact test.

FisherTest = function(sample.list, parameter) {

  # Determine the function call, either to generate the p-value or to return description
  call = (parameter[[1]] == "Description")


  if (call == FALSE | is.na(call)) {

    # No parameters are defined
    if (is.na(parameter[[2]])) {
      larger = TRUE
    }
    else {
      if (!all(names(parameter[[2]]) %in% c("larger"))) stop("Analysis model: FisherTest test: this function accepts only one argument (larger)")
      # Parameters are defined but not the larger argument
      if (!is.logical(parameter[[2]]$larger)) stop("Analysis model: FisherTest test: the larger argument must be logical (TRUE or FALSE).")
      larger = parameter[[2]]$larger
    }

  # Sample list is assumed to include two data frames that represent two analysis samples

  # Outcomes in Sample 1
  outcome1 = sample.list[[1]][, "outcome"]
  # Remove the missing values due to dropouts/incomplete observations
  outcome1.complete = outcome1[stats::complete.cases(outcome1)]

  # Outcomes in Sample 2
  outcome2 = sample.list[[2]][, "outcome"]
  # Remove the missing values due to dropouts/incomplete observations
  outcome2.complete = outcome2[stats::complete.cases(outcome2)]

  # Contingency table
  contingency.data = rbind(cbind(2, outcome2.complete), cbind(1, outcome1.complete))
  contingency.table = table(contingency.data[, 1], contingency.data[, 2])


  # One-sided p-value (treatment effect in sample 2 is expected to be greater than in sample 1)
  if (larger) result = stats::fisher.test(contingency.table, alternative = "greater")$p.value
  else result = stats::fisher.test(contingency.table, alternative = "less")$p.value

}
else if (call == TRUE) {

  result=list("Fisher exact test")
}

return(result)
}
# End of FisherTest
