#### internal files used in DEtime package

.gpPlot_DEtime <-
function(model,Xstar,ControlTimes, ControlData, PerturbedTimes, PerturbedData, mu,S,likelihood,simpose=NULL,xlim=NULL,ylim=NULL,xlab='',ylab='',col='blue',title='') {
    ## GPPLOT Plots the GP mean and variance.
    
    len_control <- length(ControlTimes)
    len_perturbed <- length(PerturbedTimes)
    len_all <- len_control + len_perturbed
    
    lstar <- dim(Xstar)[1]/2
    #f = c(mu+2*sqrt(abs(S)), rev(mu-2*sqrt(abs(S))))
    f1  = c(mu[1:lstar]+2*sqrt(abs(S[1:lstar])), rev(mu[1:lstar]-2*sqrt(abs(S[1:lstar]))))
    f2 = c(mu[(lstar+1):(2*lstar)]+2*sqrt(abs(S[(lstar+1):(2*lstar)])), rev(mu[(lstar+1):(2*lstar)]-2*sqrt(abs(S[(lstar+1):(2*lstar)]))))
    
    if (is.null(xlim))
    xlim = range((model$X[,1]))
    if (is.null(ylim))
    ylim = range(c(f1,f2))
    
    #   par(pty="s")
    old_par <- par(no.readonly=TRUE)
    #attach(mtcars)
    #layout(2,1, widths=4,heights=c(1,3))
    #par(mar=c(0,0,0,0))
    par(fig=c(0.1,1.0,0.8,1),mar=c(0.0,2.0,2.0,2.0))
    plot(likelihood, type="n", xaxt="n", yaxt="n", xlim=xlim, bty="l")
    xx <- c(likelihood[,1],rev(likelihood[,1]))
    yy <- c(rep(0,nrow(likelihood)), rev(likelihood[,2]))
    polygon(xx,yy, col=rgb(0,0,1,0.4), border=NA, xlim=range(xx), ylim=range(yy))
    #polygon(xx,yy, col=rgb(0,0,1,0.4))
    par(fig=c(0.1,1.0,0.1,0.8), mar=c(2.0,2.0,0.0,2.0),new=TRUE)
    plot(1, type="n", xlim=xlim, ylim=ylim, cex.axis=.5,cex.lab=.5, cex.main=.5, cex.sub = .5, bty="l") ## Empty plot basis.
    
    if (col=='blue') shade = rgb(0,0,1,alpha=.1)
    else if (col=='red') shade = rgb(255,0,0,alpha=.1)
    else shade = 'gray'
    
    lstar <- dim(Xstar)[1]/2
    
    mu_f <- matrix(0,nrow = len_control, ncol =1)
    mu_g <- matrix(0,nrow = len_perturbed, ncol =1)
    

    #mu_f <- aggregate(model$y[1:len_control], by=list(model$X[1:len_control,1]), FUN=mean)[2]    
    #mu_g <- aggregate(model$y[(len_control+1):len_all], by=list(model$X[(len_control+1):len_all,1]), FUN=mean)[2]    

    polygon(c(Xstar[1:lstar,1], rev(Xstar[1:lstar,1])), f1, col = rgb(0.9,1.0,1.0,1.0), border = shade)   ## Confidence intervals.
    polygon(c(Xstar[(lstar+1):(2*lstar),1], rev(Xstar[(lstar+1):(2*lstar),1])), f2, col = rgb(1,0.95,0.7,.8), border = shade) ## Confidence intervals.
    #points(model$X[1:len_control,1], model$y[1:len_control,], pch = 0, cex = .5, lwd=.5, col = 'blue')   ## Training points.
    points(model$X[1:len_control,1], ControlData, pch = 0, cex = .5, lwd=.5, col = 'blue')   ## Training points.
    #points(model$X[(len_control+1):(len_all),1], model$y[(len_control+1):(len_all),], pch = 4, cex = .5, lwd=.5, col = 'red')    ## Training points.
    points(model$X[(len_control+1):(len_all),1], PerturbedData, pch = 4, cex = .5, lwd=.5, col = 'red')    ## Training points.
    lines(Xstar[1:lstar,1], mu[1:lstar,], col='blue', lwd=.5, lty = 1)   ## Mean function.
    lines(Xstar[(lstar+1):(2*lstar),1], mu[(lstar+1):(2*lstar),], col='red', lwd=.5, lty = 1)    ## Mean function.
    #lines(model$X[1:size_x,], mu_f[1:size_x,], col='black', lwd=.5, lty = 2)  ## Mean function
    #lines(model$X[1:size_x,], mu_g[1:size_x,], col='blue', lwd=.5, lty = 2)  ## Mean function .
    #par(mar=c(0, 0, 0, 0))
    #legend("bottom", c("Original control", "Original perturbed", "Mean of control", "Mean of perturbed", "Estimated control", "Estimated perturbed"), col = c('black', 'blue', 'black','darkblue','black','blue'),text.col = "black", lty = c(NA,NA,2, 2, 1,1), pch = c(0,1, NA,NA,NA,NA), bg = "gray90", ncol=3,bty="n", cex=0.8)
    
    legend("bottom", c("Original control", "Original perturbed", "Estimated control", "Estimated perturbed"), col = c('blue', 'red','blue','red'),text.col = "black", lty = c(NA,NA,1,1), pch = c(0,4, NA,NA), bg = "gray90", ncol=3,bty="n", cex=0.8)
    
    mtext(title, side=3, line=5, cex=1, col="black")
    mtext("Gene expression", side=2, line=2, padj=0.5, cex=1, col="black")
    mtext("Time", side=1, line=2, cex=1, col="black")
    if (!is.null(simpose)) {
        y = mu[simpose] + rnorm(6, 0, exp(model$params$xmin[3]/2))
        points(simpose, y, pch = 4, cex = 0.5, lwd=3, col = col)
    }
    par(old_par)
    #zeroAxes()
}

.jitCholInv <-
function ( M, Num=10, silent=FALSE ) {
  jitter <- 0
  jitter1 <- abs(mean(diag(M)))*1e-6
  eyeM <- diag( 1, nrow=length(M[,1]), ncol=length(M[1,]) )

  for ( i in 1:Num ) {

    ## clear the last error message
    try(stop(""),TRUE)

    Ch <- try( chol( M + jitter*eyeM ), silent=TRUE )

    nPos <- grep("not positive definite",  geterrmessage())

    if ( length(nPos) != 0 ) {
      jitter1 <- jitter1*10
      jitter <- jitter1

      if (! silent) {
        warnmsg <- paste("Matrix is not positive definite, adding",
                         signif(jitter,digits=4), "jitter!")
        warning(warnmsg)
      }
    }
    else break
  }

  invCh <- try (solve( Ch, eyeM ), silent=TRUE)

  if ( class(invCh)[1] == "try-error" ) {
    return (NaN)
  }
  else {
    invM <- invCh %*% t(invCh)

    if ( jitter == 0 ) {
      ans <- list(invM=invM, jitter=jitter, chol=Ch)
    }
    else ans <- list(invM=invM, jitM=M+jitter*eyeM , jitter=jitter, chol=Ch)

    return (ans)
  }
}

.dist2 <-
function (x, x2) {
  xdim <- dim(as.matrix(x))
  x2dim <- dim(as.matrix(x2))

  xMat <- array(apply(as.matrix(x*x),1,sum), c(xdim[1], x2dim[1]))
  x2Mat <- t(array(apply(as.matrix(x2*x2),1,sum), c(x2dim[1], xdim[1])))

  if ( xdim[2] != x2dim[2] )
    stop("Data dimensions are not matched.")

  n2 <-   xMat+x2Mat-2*tcrossprod(x, x2)

  return (n2)
}

.absolutedist <-
function (x,x2) {
  xdim <- dim(as.matrix(x))
  x2dim <- dim(as.matrix(x2))

  xMat <- array(apply(as.matrix(x),1,sum), c(xdim[1], x2dim[1]))
  x2Mat <- t(array(apply(as.matrix(x2),1,sum), c(x2dim[1], xdim[1])))

  if ( xdim[2] != x2dim[2] )
    stop("Data dimensions are not matched.")
  
  n2 <- abs(xMat-x2Mat)

  return(n2)
}
