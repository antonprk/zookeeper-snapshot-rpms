## Overview
RPM build from repository SNAPSHOT. This repository contains everything needed to build RPM's for zookeeper, including libzookeeper and the devel packages. Different pieces are taken from places around the internet; the systemd script . Individual packages will be built for zookeeper, libzookeeper, and zookeeper-devel.

The spec has been tested on EL6 & EL7 with the EPEL repo enabled.
It should also work on recent Fedoras, too.

## Building
    git clone https://github.com/antonprk/zookeeper-snapshot-rpms
    cd zookeeper-snapshot-rpms
    chmod u+x build.sh; build.sh

## License
All files in this repository are licensed under the Apache 2 license. Any
redistribution of these files must include the original license as well as
attribution to this repository.
