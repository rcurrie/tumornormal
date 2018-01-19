# Deriving cancer gene's from expression data

See if it's possible to train a deep neural network tumor/normal binary classifier using just the Toil TCGA, TARGET and GTEX expression datasets:

https://xenabrowser.net/datapages/?host=https://toil.xenahubs.net)

To get started look at ingest.ipynb to wrangle the dataset and train.ipynb to (badly) classify it.

The Makefile and requirements.txt assist in testing a model on a local CPU machine and then running
on a remote shared machine with GPU's.
