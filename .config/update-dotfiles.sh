#!/bin/bash

# csFedoraDots - Fedora Dotfiles Update Script
# Description: Automatically updates and syncs dotfiles using yadm
# Author: agnid
# Repository: https://github.com/agni-datta/csFedoraDots

set -e  # Exit on any error

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

# Function to check if yadm is installed
check_yadm() {
    if ! command -v yadm &> /dev/null; then
        print_error "yadm is not installed. Please install it first:"
        echo "  sudo dnf install yadm"
        exit 1
    fi
}

# Function to show current status
show_status() {
    print_status "Checking yadm repository status..."
    echo
    yadm status
    echo
}

# Function to add modified files
add_changes() {
    print_status "Adding changes to yadm..."
    
    # Check if there are any changes to add
    if yadm diff --quiet && yadm diff --cached --quiet; then
        print_warning "No changes detected to add."
        return 0
    fi
    
    # Add all tracked files that have been modified
    yadm add -u
    print_success "Modified tracked files added successfully."
}

# Function to commit changes
commit_changes() {
    # Check if there are staged changes
    if yadm diff --cached --quiet; then
        print_warning "No staged changes to commit."
        return 0
    fi
    
    # Get current date for commit message
    local commit_date=$(date +"%Y-%m-%d %H:%M:%S")
    local commit_message="Update dotfiles - $commit_date"
    
    print_status "Committing changes with message: '$commit_message'"
    yadm commit -m "$commit_message"
    print_success "Changes committed successfully."
}

# Function to push changes
push_changes() {
    print_status "Pushing changes to remote repository..."
    
    if yadm push; then
        print_success "Changes pushed to remote repository successfully."
    else
        print_error "Failed to push changes. Please check your connection and try again."
        return 1
    fi
}

# Function to pull latest changes
pull_changes() {
    print_status "Pulling latest changes from remote repository..."
    
    if yadm pull; then
        print_success "Latest changes pulled successfully."
    else
        print_warning "Failed to pull changes. Continuing with local updates."
    fi
}

# Function to show help
show_help() {
    echo "csFedoraDots - Fedora Dotfiles Update Script"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo "  -s, --status   Show current yadm status only"
    echo "  -p, --pull     Pull latest changes from remote"
    echo "  -n, --no-push  Don't push changes to remote"
    echo "  -q, --quiet    Minimize output"
    echo
    echo "Default behavior: pull -> add -> commit -> push"
}

# Parse command line arguments
PULL_ONLY=false
NO_PUSH=false
STATUS_ONLY=false
QUIET=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        -s|--status)
            STATUS_ONLY=true
            shift
            ;;
        -p|--pull)
            PULL_ONLY=true
            shift
            ;;
        -n|--no-push)
            NO_PUSH=true
            shift
            ;;
        -q|--quiet)
            QUIET=true
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Main execution
main() {
    print_status "Starting csFedoraDots update process..."
    echo
    
    # Check if yadm is available
    check_yadm
    
    # Show status if requested
    if [[ "$STATUS_ONLY" == true ]]; then
        show_status
        exit 0
    fi
    
    # Pull latest changes if not disabled
    if [[ "$PULL_ONLY" == true ]]; then
        pull_changes
        exit 0
    fi
    
    # Show current status unless quiet mode
    if [[ "$QUIET" == false ]]; then
        show_status
    fi
    
    # Pull latest changes first
    pull_changes
    echo
    
    # Add changes
    add_changes
    echo
    
    # Commit changes
    commit_changes
    echo
    
    # Push changes unless disabled
    if [[ "$NO_PUSH" == false ]]; then
        push_changes
    else
        print_warning "Skipping push to remote repository."
    fi
    
    echo
    print_success "csFedoraDots update process completed!"
    
    # Show final status unless quiet mode
    if [[ "$QUIET" == false ]]; then
        echo
        print_status "Final repository status:"
        yadm status
    fi
}

# Run main function
main "$@"