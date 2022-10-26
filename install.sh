
OS=""
LINUX_DISTRIBUTION=""

abort() {
    printf "ERROR %s\n" "$@" >&2
    exit 1
}

log() {
    printf "################################################################################\n"
    printf "%s\n" "$@"
    printf "################################################################################\n"
}

check_prerequisite() {
    if [ -z "${BASH_VERSION:-}" ]; then
        abort "Bash is required to interpret this script"
    fi

    if [[ $EUID -eq 0 ]]; then
        abort "Script must not be run as root user"
    fi

    command -v sudo > /dev/null 2>&1 || { abort "sudo not found - please install"; }

    arch=$(uname -m)

    if [[ $arch =~ "arm" || $arch =~ "aarch64" ]]; then
        abort "Only amd64 is supported"
    fi
}

ask_yes_no() {
    echo "$1"
    select choice in "Yes" "No"; do
        case $choice in
            Yes ) echo "Going on"; break;;
            No ) exit;;
        esac
    done
}

get_os() {
    if [[ "$OSTYPE" =~ "darwin"* ]]; then
        OS="apple"
    elif [[ "$OSTYPE" =~ "linux" ]]; then
        OS="linux"
    fi
}

get_linux_distro() {
    local release
    release=$(cat /etc/*-release)
    if [[ "$release" =~ "Debian" ]]; then
        LINUX_DISTRIBUTION="debian"
    elif [[ "$release" =~ "Ubuntu" ]]; then
        LINUX_DISTRIBUTION = "ubuntu"
    elif [[ "$release" =~ "Arch" ]]; then
        LINUX_DISTRIBUTION = "arch"
    fi
}

install_brew() {
    if ! command -v brew >/dev/null 2>&1; then
        log "Installing brew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.profile"
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        log "Install gcc (recommended by brew)"
        brew install gcc
    fi
}

install_nvim_dependencies() {
    log "Installing nvim depencencies"
    brew install \
        fd \
        ripgrep \
        tmux \
        tree-sitter \
        go \
        node \
        python
    if ! command -v cargo >/dev/null 2>&1; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    fi
    sudo npm install -g typescript typescript-language-server pyright
}

install_nvim_head() {
    if ! command -v nvim >/dev/null 2>&1; then
        log "Installing Neovim HEAD"
        brew install --HEAD neovim
    elif [[ ! $(nvim --version) =~ "dev" ]]; then
        abort "nvim is installed but not HEAD version"
    else
        log "Skipping nvim installation"
    fi
}

git_clone_nvim_config() {
    local nvim_config_path = "$HOME/.config/nvim"
    local temp = "$HOME/vimtemp"
    log "Cloning Neovim config to $nvim_config_path"
    if [[ -d "$nvim_config_path" ]]; then
        abort "$nvim_config_path already exists"
    fi
    git clone https://github.com/Federicoand98/dotfiles.git "$temp"
    cp -r "$temp"/dotfiles/nvim "$nvim_config_path"
    cp "$temp"/dotfiles/install.sh "$nvim_config_path"
    rm -r "$temp"
}

main() {
    check_prerequisite
    get_os

    if [[ $OS == "linux" ]]; then
        get_linux_distro

        local common_packages="git curl gip tar unzip"

        if [[ $LINUX_DISTRIBUTION == "debian" || $LINUX_DISTRIBUTION == "ubuntu" ]]; then
            log "Running on debian based system"
            sudo apt-get update
            sudo apt-get install build-essential $common_packages
            install_brew
            install_nvim_dependencies
            install_nvim_head
            git_clone_nvim_config
        elif [[ $LINUX_DISTRIBUTION == "arch" ]]; then
            # todo
        fi
    elif [[ $OS == "apple" ]]; then
        log "Running on macos system"
        install_brew
        install_nvim_dependencies
        install_nvim_head
        git_clone_nvim_config
    fi
}

main