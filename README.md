# Classifying Gene Expression Data

See if it's possible to train a deep neural network tumor/normal binary classifier using just the Toil TCGA, TARGET and GTEX expression datasets: 

https://xenabrowser.net/datapages/?host=https://toil.xenahubs.net

To get started look at ingest.ipynb to wrangle the dataset and train.ipynb to (badly) classify it to
distinguish tumor vs. normal.

The Makefile and requirements.txt assist in testing a model on a local CPU machine and then running
on a remote shared machine with GPU's.

# Cancer Genes

A census of cancer genes can be downloaded from [COSMIC](http://cancer.sanger.ac.uk/census)
(redistribution prohibited so I have not included it in this repo) in order to reduce the number of features from 60k down to < 1k.

# Gene-Gene Interactions

To include information about gene-gene/protein-protein interactions see interactions.ipynb. The
underlying data comes from the superpathway database (super_pathways.tab and associated format
document)
