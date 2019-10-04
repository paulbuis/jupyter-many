FROM paulbuis/jupyter-beakerx

MAINTAINER Paul Buis <00pebuis@bsu.edu>

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
	file \
	libunwind-dev \
	fonts-dejavu \
	gfortran && \ 
	rm -rf /var/apt/lists/* && \
        apt-get clean -y 

USER $NB_USER
# a simple one-liner to get xeus-cling to work
# note, we are not messing with a separate conda
# environment for it, which is supposed to be used
# according to the xeus-cling docs to avoid libzmq conflicts
# don't know why it doesn't or why it would, I'm clueless

# Currently getting a conda warining about multiple inconsisties involving
# Perhaps these are coming from base beakerx image ???
#  - conda-forge/noarch::jupyter==1.0.0=py_2
#  - conda-forge/noarch::qtconsole==4.5.2=py_0
#  - conda-forge/linux-64::rise==5.5.1=py37_0
#  - conda-forge/linux-64::matplotlib==3.1.1=py37_0

RUN conda install --quiet --yes \
    'xeus-cling=0.7.1' && \
    conda clean --all -f -y && \
    fix-permissions $CONDA_DIR && \
    fix-permissions /home/$NB_USER


# note we are running the npm installed by conda, which is
# owned by $NB_USER, but located in $CONDA_DIR, not in /home/$NB_USER.

USER $NB_USER
RUN npm install -g chalk \
      date-fns \
      express \
      @babel/core @babel/cli @babel/preset-env \
      http-server \
      mathjs \
      moment \
      ramda \
      request \
      js-beautify \
      webpack webpack-cli && \
    npm install -g ijavascript && \
    ijsinstall && \
    npm install -g itypescript && \
    its --ts-hide-undefined --install=local


# iJava comes from https://github.com/SpencerPark/IJava
# It depends on jdk>=9, so make sure conda has installed updated version of openjdk
USER root
RUN mkdir /ijava && chown $NB_UID:$NB_GID /ijava

#
# Note: This replaces the beakerx java kernel with the IJava java kernel
#
USER $NB_USER
RUN jupyter kernelspec list && \
    jupyter nbextension list && \ 
    jupyter nbextension enable rise/main && \
    cd /ijava && \
    wget -q https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python3 install.py --user && \
    jupyter kernelspec list && \
    jupyter nbextension list

ENV JDK_JAVA_OPTIONS -Xcomp -Xms2g -Xmx2g -XX:-PreserveFramePointer
ENV NODE_PATH /opt/conda/lib/node_modules/
USER $NB_USER
