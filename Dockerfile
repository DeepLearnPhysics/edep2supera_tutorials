FROM deeplearnphysics/dune-nd-sim:ub20.04-cpubase-edep2supera

# root
ENV ROOTSYS=/app/root
ENV PATH="${ROOTSYS}/bin:${PATH}"
ENV LD_LIBRARY_PATH="${ROOTSYS}/lib:${LD_LIBRARY_PATH}"
ENV PYTHONPATH="${ROOTSYS}/lib:${PYTHONPATH}"

# geant4
ENV PATH="/app/geant4/bin:${PATH}"
ENV LD_LIBRARY_PATH="/app/geant4/lib:${LD_LIBRARY_PATH}"

#edepsim
ENV PATH="/app/edep/bin:${PATH}"
ENV LD_LIBRARY_PATH="/app/edep/lib:${LD_LIBRARY_PATH}"

# larcv
ENV LARCV_BASEDIR=/app/larcv2
ENV LARCV_BUILDDIR="${LARCV_BASEDIR}/build"
ENV LARCV_COREDIR="${LARCV_BASEDIR}/larcv/core"
ENV LARCV_APPDIR="${LARCV_BASEDIR}/larcv/app"
ENV LARCV_LIBDIR="${LARCV_BUILDDIR}/lib"
ENV LARCV_INCDIR="${LARCV_BUILDDIR}/include"
ENV LARCV_BINDIR="${LARCV_BUILDDIR}/bin"
ENV LARCV_ROOT6=1
ENV LARCV_CXX=g++

# with numpy
ENV LARCV_NUMPY=1
ENV LARCV_PYTHON=/usr/bin/python3
ENV LARCV_PYTHON_CONFIG=python3.8-config
ENV LARCV_INCLUDES=" -I/app/larcv2/build/include -I/usr/include/python3.8  -I/usr/local/lib/python3.8/dist-packages/numpy/core/include"
ENV LARCV_LIBS=" -L/usr/lib/ -L/usr/lib/python3.8/config-3.8-x86_64-linux-gnu -L/usr/lib  -lcrypt -lpthread -ldl  -lutil -lm -L/app/larcv2/build/lib -llarcv"

# DLPGenerator
ENV DLPGENERATOR_ROOT6=1
ENV DLPGENERATOR_CXX=g++
ENV DLPGENERATOR_NUMPY=1
ENV DLPGENERATOR_DIR=/app/DLPGenerator
ENV DLPGENERATOR_BINDIR="${DLPGENERATOR_DIR}/bin"
ENV DLPGENERATOR_INCDIR="${DLPGENERATOR_DIR}/build/include"
ENV DLPGENERATOR_BUILDDIR="${DLPGENERATOR_DIR}/build"
ENV DLPGENERATOR_LIBDIR="${DLPGENERATOR_DIR}/build/lib"

# set bin and lib path
ENV PATH=${LARCV_BASEDIR}/bin:${LARCV_BINDIR}:${DLPGENERATOR_BINDIR}:${PATH}
ENV LD_LIBRARY_PATH=${LARCV_LIBDIR}:${DLPGENERATOR_LIBDIR}:${LD_LIBRARY_PATH}:
ENV PYTHONPATH=${LARCV_BASEDIR}/python:${DLPGENERATOR_DIR}/python:${PYTHONPATH}

# for geant4
ENV G4NEUTRONHPDATA="/app/geant4/share/Geant4-10.6.3/data/G4NDL4.6"
ENV G4LEDATA="/app/geant4/share/Geant4-10.6.3/data/G4EMLOW7.9.1"
ENV G4LEVELGAMMADATA="/app/geant4/share/Geant4-10.6.3/data/PhotonEvaporation5.5"
ENV G4RADIOACTIVEDATA="/app/geant4/share/Geant4-10.6.3/data/RadioactiveDecay5.4"
ENV G4PARTICLEXSDATA="/app/geant4/share/Geant4-10.6.3/data/G4PARTICLEXS2.1"
ENV G4PIIDATA="/app/geant4/share/Geant4-10.6.3/data/G4PII1.3"
ENV G4REALSURFACEDATA="/app/geant4/share/Geant4-10.6.3/data/RealSurface2.1.1"
ENV G4SAIDXSDATA="/app/geant4/share/Geant4-10.6.3/data/G4SAIDDATA2.0"
ENV G4ABLADATA="/app/geant4/share/Geant4-10.6.3/data/G4ABLA3.1"
ENV G4INCLDATA="/app/geant4/share/Geant4-10.6.3/data/G4INCL1.0"
ENV G4ENSDFSTATEDATA="/app/geant4/share/Geant4-10.6.3/data/G4ENSDFSTATE2.2"

ENV SUPERA_WITHOUT_PYTHON=1

RUN git clone https://github.com/DeepLearnPhysics/SuperaAtomic.git && \
    cd SuperaAtomic && \
    set SUPERA_WITHOUT_PYTHON=1 && \
    python3 setup.py install && \
    cd .. && \
    git clone https://github.com/DeepLearnPhysics/edep2supera.git && \
    cd edep2supera && \
    python3 setup.py install

ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
    
# Make sure the contents of our repo are in ${HOME}
WORKDIR /app
COPY . ${HOME}
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}
