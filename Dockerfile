FROM debian:stretch@sha256:f1f61086ea01a72b30c7287adee8c929e569853de03b7c462a8ac75e0d0224c4
COPY /stretch_deps.sh /
RUN /stretch_deps.sh
