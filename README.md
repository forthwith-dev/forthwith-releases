# Forthwith CLI Releases

This repository hosts the official release binaries for the Forthwith CLI.

Forthwith CLI extracts localizable strings from your project, sends new or changed strings to Forthwith for translation, and writes translated resources back into framework-specific files.

## Prerequisites

You need a Forthwith account to use this CLI. [Sign up at forthwith.dev](https://forthwith.dev) before getting started.

## Installation

### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/forthwith-dev/forthwith-releases/main/install.sh | bash
```

### macOS (Homebrew)

```bash
brew tap forthwith-dev/forthwith
brew install forthwith
```

### Windows (Scoop)

```bash
scoop bucket add forthwith https://github.com/forthwith-dev/scoop-forthwith
scoop install forthwith
```

### Windows (Chocolatey)

```bash
choco install forthwith
```

### Manual Download
Download the binary for your platform from the Releases page.

| Platform | Architecture   | File                              |
|----------|----------------|-----------------------------------|
| macOS    | Apple Silicon  | `forthwith_darwin_arm64.tar.gz`   |
| macOS    | Intel          | `forthwith_darwin_amd64.tar.gz`   |
| Linux    | x86_64         | `forthwith_linux_amd64.tar.gz`    |
| Linux    | ARM64          | `forthwith_linux_arm64.tar.gz`    |
| Windows  | x86_64         | `forthwith_windows_amd64.zip`     |
| Windows  | ARM64          | `forthwith_windows_arm64.zip`     |

## Uninstallation
### macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/forthwith-dev/forthwith-releases/main/uninstall.sh | bash
```

## Getting Started

```bash
# Authenticate
forthwith login

# Initialize your project
forthwith init

# Translate new or changed strings
forthwith translate
```

See the full documentation for complete usage instructions.





