FROM jupyter/datascience-notebook:c7fb6660d096

USER root
RUN pip install --upgrade pip
ADD requirements.cpu.txt requirements.cpu.txt
RUN pip install --no-cache-dir -r requirements.cpu.txt

USER jovyan
