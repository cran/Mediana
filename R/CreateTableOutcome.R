############################################################################################################################

# Function: CreateTableOutcome.
# Argument: data.strucure and label (optional).
# Description: Generate a summary table of outcome parameters for the report.

CreateTableOutcome = function(data.structure, label = NULL) {

  # Number of sample ID
  n.id <- length(data.structure$id)
  id.label = c(unlist(lapply(lapply(data.structure$id, function(x) unlist(paste0("{",x,"}"))), paste0, collapse = ", ")))

  # Number of outcome
  n.outcome = length(data.structure$outcome.parameter.set)

  # Dummy call of the function to get the description
  dummy.function.call = list("description", data.structure$outcome.parameter.set[[1]][[1]])
  outcome.dist.desc = do.call(data.structure$outcome$outcome.dist, list(dummy.function.call))
  parameter.labels = outcome.dist.desc[[1]]
  outcome.dist.name = outcome.dist.desc[[2]]

  # Label
  if (is.null(label)) label = paste0("Outcome ", 1:n.outcome) else label = unlist(label)
  if (length(label) != n.outcome)
    stop("Summary: Number of the outcome parameters labels must be equal to the number of outcome parameters sets.")

  # Summary table
  outcome.table <- matrix(nrow = n.id*n.outcome, ncol = 4)
  ind <-1

  if (data.structure$outcome$outcome.dist.dim == 1) {
    for (i in 1:n.outcome) {
      for (j in 1:n.id) {
        outcome.table[ind, 1] = i
        outcome.table[ind, 2] = label[i]
        outcome.table[ind, 3] = id.label[j]
        outcome.table[ind, 4] = mergeOutcomeParameter(parameter.labels,  data.structure$outcome.parameter.set[[i]][[j]])
        ind<-ind+1
      }
    }
  }
  if (data.structure$outcome$outcome.dist.dim > 1) {
    for (i in 1:n.outcome) {
      for (j in 1:n.id) {
        par = ifelse(!is.null(parameter.labels$par),
                     paste0(mapply(function(x,y) paste0("{",mergeOutcomeParameter(x,y),"}"), parameter.labels$par, data.structure$outcome.parameter.set[[i]][[j]]$par), collapse = ", "),
                     mergeOutcomeParameter(parameter.labels,  data.structure$outcome.parameter.set[[i]][[j]])
        )
        corr = ifelse(!is.null(data.structure$outcome.parameter.set[[i]][[j]]$corr), paste0("corr = {", paste(t(data.structure$outcome.parameter.set[[i]][[j]]$corr), collapse = ","),"}", collapse = ""), NA)
        outcome.table[ind, 1] = i
        outcome.table[ind, 2] = label[i]
        outcome.table[ind, 3] = id.label[j]
        outcome.table[ind, 4] = ifelse(!is.na(corr), paste0(par, ",\n",corr),par)
        ind<-ind+1
      }
    }
  }

  outcome.table= as.data.frame(outcome.table)
  colnames(outcome.table) = c("outcome.parameter","Outcome parameter set", "Sample", "Parameter")

  return(list(outcome.dist.name,outcome.table))
}
# End of CreateTableOutcome
