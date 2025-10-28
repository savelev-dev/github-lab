#!/bin/bash

# Script to load environment variables from .env file
# Usage: source ./load_env.sh

if [ -f .env ]; then
    echo "Loading environment variables from .env file..."
    export $(grep -v '^#' .env | xargs)
    echo "Environment variables loaded successfully!"
else
    echo "Warning: .env file not found. Please create one based on .env.example"
fi