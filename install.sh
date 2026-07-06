#!/usr/bin/env bash
set -euo pipefail

REPO_SLUG="LeeJuHwan/nvim"
REPO_SSH="git@github.com:${REPO_SLUG}.git"
NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

log()  { printf "\033[1;32m==>\033[0m %s\n" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

install_macos() {
  if ! have brew; then
    log "Homebrew 설치"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  log "패키지 설치 (neovim, ripgrep, fd, node, git, gh, basedpyright)"
  brew install neovim ripgrep fd node git gh basedpyright
  log "Nerd Font 설치 (JetBrainsMono)"
  brew install --cask font-jetbrains-mono-nerd-font || true
}

install_linux() {
  if have apt-get; then
    log "패키지 설치 (apt)"
    sudo apt-get update -y
    sudo apt-get install -y neovim ripgrep fd-find nodejs npm git curl unzip
  elif have dnf; then
    log "패키지 설치 (dnf)"
    sudo dnf install -y neovim ripgrep fd-find nodejs git curl unzip
  else
    echo "지원하지 않는 배포판입니다. neovim ripgrep fd node git 을 수동 설치 후 다시 실행하세요."
    exit 1
  fi
  log "Nerd Font (JetBrainsMono) 수동 설치"
  mkdir -p "$HOME/.local/share/fonts"
  curl -fsSL -o /tmp/JetBrainsMono.zip \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
  unzip -oq /tmp/JetBrainsMono.zip -d "$HOME/.local/share/fonts"
  fc-cache -f >/dev/null 2>&1 || true
}

case "$(uname -s)" in
  Darwin) install_macos ;;
  Linux)  install_linux ;;
  *) echo "지원하지 않는 OS: $(uname -s)"; exit 1 ;;
esac

if [ -d "$NVIM_DIR/.git" ]; then
  log "기존 nvim repo 존재 → 최신화 (git pull)"
  git -C "$NVIM_DIR" pull --ff-only
else
  if [ -e "$NVIM_DIR" ]; then
    BAK="${NVIM_DIR}.bak.$(date +%Y%m%d%H%M%S)"
    log "기존 설정 백업: $NVIM_DIR -> $BAK"
    mv "$NVIM_DIR" "$BAK"
  fi
  log "설정 clone: $REPO_SLUG"
  if have gh && gh auth status >/dev/null 2>&1; then
    gh repo clone "$REPO_SLUG" "$NVIM_DIR"
  else
    git clone "$REPO_SSH" "$NVIM_DIR"
  fi
fi

log "플러그인 설치 (lazy.nvim, headless)"
nvim --headless "+Lazy! sync" +qa

log "완료. nvim 을 실행하면 mason 이 LSP 를 자동 설치합니다."
echo
echo "  터미널 폰트를 'JetBrainsMono Nerd Font' 로 설정하세요 (아이콘 표시)."
echo "  jdtls(Java17+)/gopls(Go)/rust_analyzer(Rust) 는 해당 런타임이 있어야 동작합니다."
