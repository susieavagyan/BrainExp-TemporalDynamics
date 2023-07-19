rm(list = ls())
gc()

library(oposSOM)

load("som_input_v5.Rdata")

env <- opossom.new(list(dataset.name = "v5_results.SOM",
                        
                        dim.1stLvlSom = "auto", #40
                        dim.2ndLvlSom = 10,
                        training.extension = 1,
                        rotate.SOM.portraits = 0,
                        flip.SOM.portraits = FALSE,
                        
                        activated.modules = list( "reporting" = T,
                                                  "primary.analysis" = T, 
                                                  "sample.similarity.analysis" = T,
                                                  "geneset.analysis" = T, 
                                                  "psf.analysis" = F,
                                                  "group.analysis" = T,
                                                  "difference.analysis" = F ),
                        
                        database.biomart = "ENSEMBL_MART_ENSEMBL",
                        database.host = "jan2020.archive.ensembl.org",
                        database.dataset = "auto",
                        database.id.type = "",
                        
                        standard.spot.modules = "overexpression",
                        spot.coresize.modules = 5,
                        spot.threshold.modules = 0.95,
                        spot.coresize.groupmap = 5,
                        spot.threshold.groupmap = 0.90,
                        
                        feature.centralization = T,
                        sample.quantile.normalization = T,
                        
                        pairwise.comparison.list = list() ) )


env$indata <- indata
env$group.labels <- group.labels
env$combat.batch <- batch

opossom.run(env)

