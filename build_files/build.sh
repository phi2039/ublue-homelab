#!/bin/bash

set -ouex pipefail

/ctx/incus-install.sh
/ctx/k3s-install.sh
/ctx/other-install.sh
