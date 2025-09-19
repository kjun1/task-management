#!/bin/bash

echo "🚀 Setting up Hugo development environment in Dev Container..."

# Update package lists
sudo apt-get update

# Install Hugo extended version
HUGO_VERSION="0.150.0"
echo "📦 Installing Hugo Extended v${HUGO_VERSION}..."
wget -O hugo.deb "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.deb"
sudo dpkg -i hugo.deb
rm hugo.deb

# Install additional dependencies
echo "🔧 Installing additional tools..."
sudo apt-get install -y \
    git \
    curl \
    wget \
    tree \
    make

# Install npm packages if package.json exists
if [ -f "package.json" ]; then
    echo "📦 Installing npm dependencies..."
    npm install
fi

# Initialize git submodules
echo "🔗 Initializing git submodules..."
git submodule update --init --recursive

# Verify Hugo installation
echo "✅ Verifying installation..."
hugo version
node --version
npm --version

echo ""
echo "🎉 Hugo development environment setup complete!"
echo "📝 Available commands:"
echo "  • make serve          - Start development server"
echo "  • make serve-drafts    - Start server with drafts"
echo "  • make test           - Run quality checks"
echo "  • make help           - Show all available commands"
echo ""
echo "🌐 Run 'make serve' to start the Hugo development server"