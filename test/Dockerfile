FROM ubuntu:latest

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    ansible-core \
    git \
    sudo \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Configure passwordless sudo for root (for Ansible become)
RUN echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set working directory
WORKDIR /workspace

# Copy playbook files
COPY . /workspace/

# Default command (can be overridden)
CMD ["ansible-playbook", "main.yml", "--check", "--diff"]

