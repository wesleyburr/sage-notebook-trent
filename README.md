# sage-notebook [![Build Status](https://travis-ci.org/wesleyburr/sage-notebook-trent.svg?branch=master)](https://travis-ci.org/wesleyburr/sage-notebook-trent)
sage-notebook-trent is a community maintained Jupyter Docker Stack image with the sagemath kernel (set to 9.3), specifically configured to
include necessary extensions for teaching baseline.

Like jupyter packages in the base image, the sagemath environment is installed via conda from conda-forge as per http://doc.sagemath.org/html/en/installation/conda.html. Sagemath's environmental variables are added to the sagemath kernel so that it can be cleanly executed by jupyter while still allowing sagemath to maintain its own curated collection of libraries.

Development of conda sage packages appears to be tracked at https://wiki.sagemath.org/Conda

# Launch on binder
Try this Jupyter Notebook online with this link. No installation is needed.
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/wesleyburr/sage-notebook-trent/main)

# Docker Hub
* Docker Hub [hub.docker.com/r/wesleyburr/sage-notebook-trent](https://hub.docker.com/r/wesleyburr/sage-notebook-trent)

Docker Pull Command for Docker image with **sagemath Kernel** installed.
```
docker pull wesleyburr/sage-notebook-trent
```

# GitHub
* GitHub [github.com/wesleyburr/sage-notebook-trent](https://github.com/wesleyburr/sage-notebook-trent)

# References
## sagemath kernel
This Dockerfile is made possible by the work of https://sagemath.org/

## Jupyter Docker Stacks - Community Stack version
This project is developed with the helpful guide of [Jupyter Docker Stacks](https://jupyter-docker-stacks.readthedocs.io/en/latest/). The base container is **jupyter/minimal-notebook** and this **Community Stack** is setup [via the guide.](https://jupyter-docker-stacks.readthedocs.io/en/latest/contributing/stacks.html)

## Credit
This work was originally created by [github.com/sharptrick/sage-notebook](SharpTrick), and cloned and modified for local use.
