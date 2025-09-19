#!/bin/bash

# Update package lists
sudo apt-get update

# Install Hugo extended version
HUGO_VERSION="0.150.0"
wget -O hugo.deb "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb"
sudo dpkg -i hugo.deb
rm hugo.deb

# Install additional dependencies
sudo apt-get install -y \
    git \
    curl \
    wget \
    tree

# Verify Hugo installation
hugo version

echo "Hugo development environment setup complete!"
echo "Run 'hugo server --bind 0.0.0.0 --port 1313' to start the development server"