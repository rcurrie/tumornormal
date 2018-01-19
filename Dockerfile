FROM jupyter/datascience-notebook:c7fb6660d096

USER root
RUN pip install tensorflow keras h5py tables

USER jovyan
