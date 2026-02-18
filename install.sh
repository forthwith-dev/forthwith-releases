#!/bin/sh
set -eu

REPO="forthwith-dev/forthwith-releases"
BINARY_NAME="forthwith"
INSTALL_DIR="${FORTHWITH_INSTALL_DIR:-/usr/local/bin}"

main() {
    os="$(detect_os)"
    arch="$(detect_arch)"

    if [ -z "$os" ] || [ -z "$arch" ]; then
        echo "Error: unsupported platform: $(uname -s)/$(uname -m)" >&2
        exit 1
    fi

    version="$(get_latest_version)"
    if [ -z "$version" ]; then
        echo "Error: could not determine latest version" >&2
        exit 1
    fi

    archive="forthwith_${version#v}_${os}_${arch}.tar.gz"
    url="https://github.com/${REPO}/releases/download/${version}/${archive}"
    checksums_url="https://github.com/${REPO}/releases/download/${version}/checksums.txt"

    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT

    echo "Downloading ${BINARY_NAME} ${version} for ${os}/${arch}..."
    curl -sSfL "$url" -o "$tmpdir/$archive"
    curl -sSfL "$checksums_url" -o "$tmpdir/checksums.txt"

    echo "Verifying checksum..."
    verify_checksum "$tmpdir" "$archive"

    echo "Extracting..."
    tar -xzf "$tmpdir/$archive" -C "$tmpdir"

    echo "Installing to ${INSTALL_DIR}..."
    install_binary "$tmpdir/$BINARY_NAME" "$INSTALL_DIR/$BINARY_NAME"

    echo "Successfully installed ${BINARY_NAME} ${version} to ${INSTALL_DIR}/${BINARY_NAME}"
}

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "darwin" ;;
        Linux)  echo "linux" ;;
        *)      echo "" ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64|amd64)  echo "amd64" ;;
        aarch64|arm64) echo "arm64" ;;
        *)             echo "" ;;
    esac
}

get_latest_version() {
    curl -sSfL -H "Accept: application/json" \
        "https://api.github.com/repos/${REPO}/releases/latest" 2>/dev/null |
        sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
}

verify_checksum() {
    dir="$1"
    file="$2"
    expected="$(grep "$file" "$dir/checksums.txt" | awk '{print $1}')"

    if [ -z "$expected" ]; then
        echo "Error: checksum not found for $file" >&2
        exit 1
    fi

    if command -v sha256sum >/dev/null 2>&1; then
        actual="$(sha256sum "$dir/$file" | awk '{print $1}')"
    elif command -v shasum >/dev/null 2>&1; then
        actual="$(shasum -a 256 "$dir/$file" | awk '{print $1}')"
    else
        echo "Warning: no sha256 tool found, skipping checksum verification" >&2
        return
    fi

    if [ "$expected" != "$actual" ]; then
        echo "Error: checksum mismatch" >&2
        echo "  expected: $expected" >&2
        echo "  actual:   $actual" >&2
        exit 1
    fi
}

install_binary() {
    src="$1"
    dest="$2"
    dest_dir="$(dirname "$dest")"

    if [ ! -d "$dest_dir" ]; then
        mkdir -p "$dest_dir" 2>/dev/null || sudo mkdir -p "$dest_dir"
    fi

    chmod +x "$src"

    if [ -w "$dest_dir" ]; then
        cp "$src" "$dest"
    else
        sudo cp "$src" "$dest"
    fi
}

main
