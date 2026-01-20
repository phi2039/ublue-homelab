#!/usr/bin/sh

set -e

echo "Usage: $0 ISO BUTANE INSTALL_DISK"

INPUT_ISO=${1:-"fedora-coreos.iso"}
INPUT_BUTANE=${2:-"ucore-autorebase.bu"}
INSTALL_DISK=${3:-"/dev/vda"}
OUTPUT_IGNITION="${INPUT_BUTANE%.bu}.ign"
OUTPUT_ISO=ignition.iso

if [ ! -f fedora-coreos.iso ]; then
    echo "Downloading Fedora coreos"
    FCOS_ISO=$(podman run --rm -v $(pwd):/data:rw,Z quay.io/coreos/coreos-installer:release \
        download -f iso --decompress -C /data)
    FCOS_ISO="${FCOS_ISO#/data/}"
    mv "$FCOS_ISO" fedora-coreos.iso
fi

echo "Generating ignition"
butane --pretty --strict "$INPUT_BUTANE" --output "$OUTPUT_IGNITION"
podman run --rm -i quay.io/coreos/ignition-validate:release - < $OUTPUT_IGNITION

if [ -f "$OUTPUT_ISO" ]; then
    rm "$OUTPUT_ISO"
fi

echo "Embedding ignition"
podman run --rm \
    -v $(pwd):/data:rw,Z \
    -w /data \
    quay.io/coreos/coreos-installer:release iso customize \
    --dest-ignition "$OUTPUT_IGNITION" \
    --dest-device "$INSTALL_DISK" \
    -o "$OUTPUT_ISO" \
    $INPUT_ISO

chmod a+r $OUTPUT_ISO
echo "Created $OUTPUT_ISO"

echo "Cleaning up..."
rm $OUTPUT_IGNITION
