FROM jupyter/datascience-notebook

USER jovyan

RUN pip2 install --upgrade pip
RUN pip3 install --upgrade pip

# Install Python 2 & 3 Additional Packages for Notebooks
ADD requirements.txt requirements.txt
RUN pip2 install -r requirements.txt 
RUN pip3 install -r requirements.txt 

# Run as root so we can access everything under /data
USER root
