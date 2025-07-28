#!/bin/bash

set -e  # Interrompe lo script in caso di errore

# Colori per output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funzione per log colorati
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 4. Installazione Homebrew
log_info "Installazione Homebrew..."
if command -v brew &> /dev/null; then
    log_warning "Homebrew già installato, saltando..."
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Configurazione PATH per Homebrew
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    log_success "Homebrew installato"
fi

# 4.1 Configurazione ambiente Homebrew
log_info "Configurazione ambiente Homebrew..."
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# 4.2 Installazione build-essential per Homebrew
log_info "Installazione build-essential..."
sudo apt-get install -y build-essential
log_success "build-essential installato"

# 4.3 Installazione GCC via Homebrew
log_info "Installazione GCC via Homebrew..."
if brew list gcc &>/dev/null; then
    log_warning "GCC già installato via Homebrew, saltando..."
else
    brew install gcc
    log_success "GCC installato via Homebrew"
fi

# 5. Installazione K9s via Homebrew
log_info "Installazione K9s..."
if command -v k9s &> /dev/null; then
    log_warning "K9s già installato, saltando..."
else
    brew install derailed/k9s/k9s
    log_success "K9s installato"
fi

# 6. Installazione Helm
log_info "Installazione Helm..."
if command -v helm &> /dev/null; then
    log_warning "Helm già installato, saltando..."
else
    brew install helm
    log_success "Helm installato"
fi

# Aggiungi editor K9s se non esiste già
if ! grep -q "export K9S_EDITOR=nano" ~/.bashrc; then
    echo "export K9S_EDITOR=nano" >> ~/.bashrc
    log_success "Editor K9s configurato (nano)"
else
    log_warning "Editor K9s già configurato"
fi