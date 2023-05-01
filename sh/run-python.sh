#!/bin/bash

# Initialize variables
arg=""
initialize="false"
program=""

# Parse arguments
while [ "$#" -gt 0 ]; do
  case "$1" in
    --init)
      initialize="true"
      shift
      ;;
    *)
      if [ -z "$program" ]; then
        program="$1"
      else
        echo "Error: Too many arguments provided."
        exit 1
      fi
      shift
      ;;
  esac
done

# Show usage if no program is specified
if [ -z "$program" ]; then
  echo "-------------------------------------------------------------------------------"
  echo "Please follow the instructions below to run your Python program with this script:"
  echo ""
  echo "1. Open a terminal"
  echo ""
  echo "2. Navigate to the directory containing both this .sh file"
  echo "   and your Python program."
  echo ""
  echo "3. Run the following command, replacing 'your_python_program.py' with the name"
  echo "   of your Python program:"
  echo ""
  echo "      ./$0 your_python_program.py"
  echo ""
  echo "Optional: Add --init after your program name to install/update requirements."
  echo "Example: ./$0 your_python_program.py --init"
  echo ""
  echo "-------------------------------------------------------------------------------"
  exit 0
fi

# Check if a virtual environment exists, create one if not
if [ ! -d ".venv" ]; then
  echo "Creating a new virtual environment..."
  python3 -m venv .venv
else
  echo "Virtual environment already exists."
fi

# Activate the virtual environment
echo "Activating the virtual environment..."
source .venv/bin/activate

# Check if requirements.txt exists and install packages if --init option is given
if [ "$initialize" = "true" ]; then
  if [ -f "requirements.txt" ]; then
    echo "Installing/Updating requirements..."
    python -m pip install --upgrade pip
    python -m pip install -r requirements.txt
  else
    echo "No requirements.txt file found. Skipping package installation."
  fi
fi

echo "Running the specified Python program: $program"
python "$program"

# Deactivate the virtual environment
echo "Deactivating the virtual environment..."
deactivate
