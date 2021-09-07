ARG SAGE_VERSION=9.0
ARG SAGE_PYTHON_VERSION=3.7
ARG BASE_CONTAINER=jupyter/datascience-notebook
FROM $BASE_CONTAINER

USER root

# Sage pre-requisites and jq for manipulating json
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    dvipng \
    ffmpeg \
    imagemagick \
    texlive \
    tk tk-dev \
    jq  \
    libx11-dev \
    libxt-dev \
    libice-dev \
    libsm-dev \
    libxau-dev \
    libxdmcp-dev \
    libxpm-dev \
    xvfb \
    sbcl && \
    rm -rf /var/lib/apt/lists/*

USER $NB_UID

# Initialize conda for shell interaction
RUN conda init bash

# Install Sage conda environment
RUN conda install --quiet --yes -n base -c conda-forge widgetsnbextension && \
    conda install -c conda-forge jupyter_nbextensions_configurator && \
    conda install -c conda-forge jupyter_contrib_nbextensions && \
    conda create --quiet --yes -n sage -c conda-forge sage=$SAGE_VERSION python=$SAGE_PYTHON_VERSION && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install sagemath kernel and extensions using conda run:
#   Create jupyter directories if they are missing
#   Add environmental variables to sage kernal using jq
RUN echo ' \
        from sage.repl.ipython_kernel.install import SageKernelSpec; \
        SageKernelSpec.update(prefix=os.environ["CONDA_DIR"]); \
    ' | conda run -n sage sage && \
    echo ' \
        cat $SAGE_ROOT/etc/conda/activate.d/sage-activate.sh | \
            grep -Po '"'"'(?<=^export )[A-Z_]+(?=)'"'"' | \
            jq --raw-input '"'"'.'"'"' | jq -s '"'"'.'"'"' | \
            jq --argfile kernel $SAGE_LOCAL/share/jupyter/kernels/sagemath/kernel.json \
            '"'"'. | map(. as $k | env | .[$k] as $v | {($k):$v}) | add as $vars | $kernel | .env= $vars'"'"' > \
            $CONDA_DIR/share/jupyter/kernels/sagemath/kernel.json \
    ' | conda run -n sage sh && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install sage's python kernel
RUN echo ' \
        ls /opt/conda/envs/sage/share/jupyter/kernels/ | \
            grep -Po '"'"'python\d'"'"' | \
            xargs -I % sh -c '"'"' \
                cd $SAGE_LOCAL/share/jupyter/kernels/% && \
                cat kernel.json | \
                    jq '"'"'"'"'"'"'"'"' . | .display_name = .display_name + " (sage)" '"'"'"'"'"'"'"'"' > \
                    kernel.json.modified && \
                mv -f kernel.json.modified kernel.json && \
                ln  -s $SAGE_LOCAL/share/jupyter/kernels/% $CONDA_DIR/share/jupyter/kernels/%_sage \
            '"'"' \
    ' | conda run -n sage sh && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER

# Install FriCAS
#RUN git clone --depth 1 https://github.com/fricas/fricas
#RUN mkdir fr-build && cd fr-build && ../fricas/configure --with-lisp="sbcl --dynamic-space-size 4096" --prefix=/tmp/usr --enable-gnmp --enable-aldor && \
##    make && make install

