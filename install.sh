#!/usr/bin/env sh

set -eu

case "$(uname -s)" in
    Darwin)
        OS="macOS"
        ;;
    Linux)
        OS="Linux"
        ;;
    *)
        echo "Unsupported operating system: $(uname -s)"
        exit 1
        ;;
esac

SCRIPT="$(curl -s https://raw.githubusercontent.com/T1mVo/incognito/main/src/incognito)"

if [ -z "$SCRIPT" ]; then
    echo "Failed to download the script."
    exit 1
fi

INSTALL_PATH="/usr/local/bin/incognito"

echo "Installing to $INSTALL_PATH"

echo "$SCRIPT" | sudo tee "$INSTALL_PATH" > /dev/null
sudo chmod +x "$INSTALL_PATH"

echo "Installation complete. You can now run 'incognito'."
