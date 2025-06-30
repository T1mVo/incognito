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

```bash
# Enter incognito mode
incognito enter

# Check current status
incognito status

# Exit incognito mode
incognito exit

# Exit incognito mode without clearing the history
incognito exit --keep-history

# Show help
incognito help
```

## Auto-exit on shell exit

To automatically exit incognito mode when your shell terminates, add this line to your `.zshrc`:

```bash
eval "$(incognito setup)"
```
