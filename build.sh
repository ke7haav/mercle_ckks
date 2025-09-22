#!/bin/bash

# Simple build script for Mercle SDE Assignment

echo "Building homomorphic encryption demo..."

# Create build directory
mkdir -p build
cd build

# Configure and build
cmake -DCMAKE_PREFIX_PATH=/usr/local ..
make -j$(nproc)

echo "Build completed! Run with: ./run_demo.sh"
