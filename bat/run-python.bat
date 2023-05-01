@echo off

:: Initialize variables
set "arg="
set "initialize=false"
set "program="

:parseArgs
if "%1" EQU "" goto :argsParsed
if /i "%1" EQU "--init" (
    set "initialize=true"
) else (
    if not defined program (
        set "program=%1"
    ) else (
        echo Error: Too many arguments provided.
        goto :eof
    )
)
shift
goto :parseArgs

:argsParsed
if not defined program (
    echo -------------------------------------------------------------------------------
    echo Please follow the instructions below to run your Python program with this script:
    echo.
    echo 1. Open a command prompt ^(cmd.exe^) or PowerShell window
    echo.
    echo 2. Navigate to the directory containing both this .bat file
    echo    and your Python program.
    echo.
    echo 3. Run the following command, replacing 'your_python_program.py' with the name
    echo    of your Python program:
    echo.
    echo       %~nx0 your_python_program.py
    echo.
    echo Optional: Add --init after your program name to install/update requirements.
    echo Example: %~nx0 your_python_program.py --init
    echo.
    echo -------------------------------------------------------------------------------
    pause > nul
    goto :eof
)

:: Check if a virtual environment exists, create one if not
if not exist ".venv" (
    echo Creating a new virtual environment...
    python -m venv .venv
) else (
    echo Virtual environment already exists.
)

:: Activate the virtual environment
echo Activating the virtual environment...
call .venv\Scripts\activate.bat

:: Check if requirements.txt exists and install packages if --init option is given
if "%initialize%" EQU "true" (
    if exist "requirements.txt" (
        echo Installing/Updating requirements...
        python -m pip install --upgrade pip
        python -m pip install -r requirements.txt
    ) else (
        echo No requirements.txt file found. Skipping package installation.
    )
)

echo Running the specified Python program: %program%
python %program%

:: Deactivate the virtual environment
echo Deactivating the virtual environment...
call deactivate.bat