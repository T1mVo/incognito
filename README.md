# incognito

A zsh utility for temporarily disabling command history logging.

## Features

- 🕵️ **Incognito Mode**: Disable command history
- 🧹 **Auto-cleanup**: Cleans history on shell exit
- 🖥️ **Cross-platform**: Works on macOS and Linux

**Note**: Make sure `$HISTFILE` is set and exported.

## Installation

### Via Homebrew (Recommended)

```bash
# Add the tap
brew tap T1mVo/tap

# Install incognito
brew install incognito
```

### Manual Installation

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/T1mVo/incognito/main/install.sh)"
```

## Usage

### Basic Commands

```bash
# Enter incognito mode
incognito enter

# Check current status
incognito status

# Exit incognito mode (removes commands from history)
incognito exit

# Show help
incognito help
```
