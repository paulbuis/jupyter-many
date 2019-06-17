FROM paulbuis/jupyter-beakerx

MAINTAINER Paul Buis <00pebuis@bsu.edu>

USER $NB_USER
# a simple one-liner to get xeus-cling to work
# note, we are not messing with a separate conda
# environment for it, which is supposed to be used
# according to the xeus-cling docs to avoid libzmq conflicts
# don't know why it doesn't or why it would, I'm clueless

# Currently getting a conda warining about an inconsistecy involving
# conda-forge/linux-64::matplotlib==3.0.3=py37_1

RUN conda install -y \
      'xeus-cling=0.5.1' \

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
    cd /ijava && \
    wget -q https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip && \
    unzip ijava-1.3.0.zip && \
    python3 install.py --user && \
    jupyter kernelspec list

ENV JDK_JAVA_OPTIONS -Xcomp -Xms2g -Xmx2g -XX:-PreserveFramePointer
USER $NB_USER
