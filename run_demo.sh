#!/bin/bash

# Mercle SDE Assignment - Demo Script
# This script compiles and runs the homomorphic encryption demo

set -e  # Exit on any error

echo "=========================================="
echo "Mercle SDE Assignment - HE Demo"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if OpenFHE is installed
print_status "Checking OpenFHE installation..."
if [ ! -d "/usr/local/include/openfhe" ]; then
    print_error "OpenFHE not found in /usr/local/include/openfhe"
    print_error "Please install OpenFHE first"
    exit 1
fi

if [ ! -f "/usr/local/lib/libOPENFHEpke.so" ]; then
    print_error "OpenFHE libraries not found in /usr/local/lib"
    print_error "Please install OpenFHE first"
    exit 1
fi

print_success "OpenFHE installation found"

# Create build directory if it doesn't exist
print_status "Setting up build environment..."
if [ ! -d "build" ]; then
    mkdir -p build
    print_status "Created build directory"
fi

# Change to build directory
cd build

# Configure with CMake
print_status "Configuring CMake..."
cmake -DCMAKE_PREFIX_PATH=/usr/local .. || {
    print_error "CMake configuration failed"
    exit 1
}
print_success "CMake configuration completed"

# Compile the project
print_status "Compiling project..."
make -j$(nproc) || {
    print_error "Compilation failed"
    exit 1
}
print_success "Compilation completed"

# Set library path
export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# Run the demo
print_status "Running homomorphic encryption demo..."
print_warning "This may take 30-60 seconds depending on your system"
echo ""

# Run with timeout to prevent hanging
timeout 120 ./demo || {
    if [ $? -eq 124 ]; then
        print_error "Demo timed out after 2 minutes"
        print_warning "This might be due to system resource limitations"
        print_warning "Try running with smaller parameters in the source code"
    else
        print_error "Demo failed with exit code $?"
    fi
    exit 1
}

print_success "Demo completed successfully!"
echo ""
print_status "Demo Summary:"
print_status "- Generated 100 random 64-dimensional vectors"
print_status "- Computed encrypted cosine similarities"
print_status "- Performed threshold decision (isUnique = maxSim < 0.5)"
print_status "- Decrypted only the final result (privacy-preserving)"
echo ""
print_status "For full assignment details, see README.md and Design_Note.md"
