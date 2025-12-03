# Multi-stage Dockerfile for testing shellkit configuration
FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages
RUN apt-get update && apt-get install -y \
    bash \
    zsh \
    git \
    curl \
    wget \
    vim \
    sudo \
    locales \
    ca-certificates \
    # Modern CLI tools
    fd-find \
    ripgrep \
    bat \
    exa \
    # Additional utilities
    net-tools \
    iputils-ping \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks for fd (Ubuntu names it fdfind)
RUN ln -s $(which fdfind) /usr/local/bin/fd || true

# Set up locale
RUN locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Install starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

# Create a test user
RUN useradd -m -s /bin/bash testuser && \
    echo "testuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to test user
USER testuser
WORKDIR /home/testuser

# Copy shellkit files
COPY --chown=testuser:testuser . /home/testuser/shellkit/

# Install Homebrew as testuser
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH and install packages
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && \
    brew install fzf zoxide fd bat ripgrep eza sd

# Configure Homebrew environment for subsequent RUN commands
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

# Set up bash configuration
RUN echo '[ -f "$HOME/shellkit/init.sh" ] && source "$HOME/shellkit/init.sh"' >> /home/testuser/.bashrc

# Set up zsh configuration
RUN touch /home/testuser/.zshrc && \
    echo '[ -f "$HOME/shellkit/init.sh" ] && source "$HOME/shellkit/init.sh"' >> /home/testuser/.zshrc

# Create sample workspace directory
RUN mkdir -p /home/testuser/ws/sample-project && \
    echo "# Sample Project" > /home/testuser/ws/sample-project/README.md

# Create local overrides example
RUN cp /home/testuser/shellkit/.env.example /home/testuser/shellkit/.env.local

CMD ["/bin/bash"]
