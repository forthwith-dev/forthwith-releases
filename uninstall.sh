#!/bin/sh
set -eu

BINARY_NAME="forthwith"
INSTALL_DIR="${FORTHWITH_INSTALL_DIR:-/usr/local/bin}"
BINARY_PATH="${INSTALL_DIR}/${BINARY_NAME}"

main() {
    if [ ! -f "$BINARY_PATH" ]; then
        echo "${BINARY_NAME} is not installed at ${BINARY_PATH}"
        exit 0
    fi

    printf "Remove %s from %s? [y/N] " "$BINARY_NAME" "$INSTALL_DIR"
    read -r answer
    case "$answer" in
        [Yy]|[Yy][Ee][Ss])
            remove_binary
            echo "Successfully removed ${BINARY_NAME} from ${INSTALL_DIR}"
            ;;
        *)
            echo "Cancelled"
            exit 0
            ;;
    esac
}

remove_binary() {
    if [ -w "$INSTALL_DIR" ]; then
        rm -f "$BINARY_PATH"
    else
        sudo rm -f "$BINARY_PATH"
    fi
}

main
