# Python Installation Script

This repository contains a script that automates the process of installing Python on Windows systems.

## Functionality

- **Automatic Installation**: The script handles the entire installation process automatically, from downloading the Python installer to configuring the installation options.
- **Requirements**: It requires a Windows operating system with an active internet connection.
- **Customizable Python Version**: While the default Python version included in the script is `3.10.11`, users can easily modify it by replacing the URL with the desired version available on the [Python official website](https://www.python.org/downloads/windows/).

## Usage

1. **Download Script**: Users can download the provided `.bat` file from this repository or create a new file using a text editor and save it with the `.bat` extension.

2. The script is configured to run with **administrator privileges** automatically to ensure successful installation.

3. **Execution**: Upon execution, the script automatically checks if Python is already installed. If not, it proceeds to download and install Python. If Python is already installed, the script notifies the user accordingly.

## Script

The repository contains a `.bat` script that encapsulates the installation process. The script is thoroughly documented for ease of understanding and customization.

```batch
@echo off
SETLOCAL EnableDelayedExpansion

:::: Run as administrator
1>nul 2>nul fltmc || (
    set "_=call "%~dpfx0" %*" & powershell -nop -c start cmd -args '/d/x/r',$env:_ -verb runas || (
    >"%temp%\Elevate.vbs" echo CreateObject^("Shell.Application"^).ShellExecute "%~dpfx0", "%*" , "", "runas", 1
    >nul "%temp%\Elevate.vbs" & del /q "%temp%\Elevate.vbs" )
    exit)

:::: Set URL to download Python
set "URL=https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe"

:::: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python is not installed.
    echo Downloading Python from %URL% ...
    bitsadmin /transfer "DownloadPython" %URL% "%TEMP%\python-3.10.11-amd64.exe"
    
    :::: Start Python installation without user interaction and add Python to the system PATH
    echo Installing Python...
    start /wait "" "%TEMP%\python-3.10.11-amd64.exe" /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
    
    :::: Delete the Python installer after installation to free up space
    del /f /q "%TEMP%\python-3.10.11-amd64.exe"    
    
) else (
    echo Python is already installed.
)

endlocal
echo Done.
pause
```

## Additional Notes

- Upon execution, the script will download the Python installer, install Python silently (without user interaction), and add Python to the system PATH.
- After installation, the Python installer is deleted from the temporary directory to free up space.

## Disclaimer
This script is provided as-is, without any warranties or guarantees. Use it at your own risk. Make sure to review and understand the script before executing it.
