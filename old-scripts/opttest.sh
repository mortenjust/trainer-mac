#!/bin/bash


 # Transform long options to short ones
for arg in "$@"; do
  shift
  case "$arg" in
    "--help") set -- "$@" "-h" ;;
    "--rest") set -- "$@" "-r" ;;
    "--ws")   set -- "$@" "-w" ;;
    *)        set -- "$@" "$arg"
  esac
done


print_usage(){
    echo "This is how we party"
}



# Default behavior
rest=false; ws=false

# Parse short options
OPTIND=1
while getopts "hrw" opt
do
  case "$opt" in
    "h") print_usage; exit 0 ;;
    "r") rest=true ;;
    "w") ws=true ;;
    "?") print_usage >&2; exit 1 ;;
  esac
done
shift $(expr $OPTIND - 1) # remove options from positional parameters
