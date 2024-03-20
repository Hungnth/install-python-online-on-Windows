@echo off
SETLOCAL EnableDelayedExpansion

:::: Run as administrator, AveYo: ps\vbs version
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
    bitsadmin /transfer "DownloadPython" %URL% "%TEMP%\install_python.exe"
    
    :::: Start Python installation without user interaction and add Python to the system PATH
    echo Installing Python...
    start /wait "" "%TEMP%\install_python.exe" /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
    
    :::: Delete the Python installer after installation to free up space
    del /f /q "%TEMP%\install_python.exe"    
    
) else (
    echo Python is already installed.
)

endlocal
echo Done.
pause
