gpGradient <- function(params, model) {

  model = gpExpandParam(model, params)
  ## only necessary parts from gpLogLikeGradients implemented!

#   if (model$optimiseBeta && !model$fixInducing)
#     browser()

  g = - gptk:::gpLogLikeGradients(model)

  return (g)
}
