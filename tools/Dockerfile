# SPDX-License-Identifier: Apache-2.0
# Dockerfile -- the open-source tools of tools/versions.lock in one
# image: Verilator, Icarus Verilog, Verible, cocotb, GNU Make, Git.
# Vivado is not in it: AMD's licence does not allow redistributing
# Vivado, so it is installed natively (book Chapter 2, Appendix B).
#
#   docker build -t loom-oss -f tools/Dockerfile .
#   docker run --rm -it -u "$(id -u):$(id -g)" -e HOME=/tmp \
#     -v "$PWD:/work" -w /work loom-oss tools/check.sh

# Stage 1: build the simulators from source (tools/install-oss.sh).
FROM ubuntu:24.04 AS build
RUN apt-get update && apt-get install -y --no-install-recommends \
      autoconf bison ca-certificates curl flex g++ gperf help2man \
      libfl-dev make perl python3 zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
COPY tools/versions.lock tools/install-oss.sh /src/tools/
RUN /src/tools/install-oss.sh /opt/loom-oss

# Stage 2: what the checks need at run time. Verilator compiles the
# C++ it generates, so g++ and make stay; cocotb needs libpython.
FROM ubuntu:24.04
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates g++ git libfl-dev make perl python3 \
      python3-dev python3-venv zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /opt/loom-oss /opt/loom-oss
COPY tools/versions.lock /opt/loom-oss/versions.lock
RUN v=$(sed -n 's/^cocotb *= *"\([^"]*\)".*/\1/p' \
          /opt/loom-oss/versions.lock) \
    && python3 -m venv /opt/loom-py \
    && /opt/loom-py/bin/pip install --no-cache-dir "cocotb==$v"
ENV PATH=/opt/loom-py/bin:/opt/loom-oss/bin:$PATH
