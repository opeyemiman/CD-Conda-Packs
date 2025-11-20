@echo off
setlocal enabledelayedexpansion

REM ==========================================
REM   Voila Notebook Launcher (Crash_Daddy)
REM ==========================================

set "ENV_DIR=%~dp0crash_daddy"
set "PYTHON_EXE=%ENV_DIR%\python.exe"

if not exist "%PYTHON_EXE%" (
    echo [ERROR] Python not found in crash_daddy environment!
    pause
    exit /b
)

echo.
echo ==========================================
echo        Voila Notebook Launcher
echo ==========================================
echo.

REM --- Re-register Jupyter kernel to fix stale paths ---
echo Checking Jupyter kernel registration...
"%PYTHON_EXE%" -m jupyter kernelspec list | findstr /C:"crash_daddy" >nul
if %errorlevel% neq 0 (
    echo Kernel not found. Registering crash_daddy kernel...
    "%PYTHON_EXE%" -m ipykernel install --user --name crash_daddy --display-name "Python (crash_daddy)"
) else (
    echo Refreshing kernel spec to ensure correct Python path...
    jupyter kernelspec remove crash_daddy -f >nul 2>&1
    "%PYTHON_EXE%" -m ipykernel install --user --name crash_daddy --display-name "Python (crash_daddy)"
)

REM --- List notebooks in current folder ---
set count=0
for %%f in (*.ipynb) do (
    set /a count+=1
    set "nb[!count!]=%%f"
    echo !count!. %%f
)

if %count%==0 (
    echo No notebooks found in this folder.
    pause
    exit /b
)

echo.
set /p choice=Select a notebook number to launch: 

set "selected=!nb[%choice%]!"

if not defined selected (
    echo Invalid choice.
    pause
    exit /b
)

echo.
echo You selected: "!selected!"

REM --- Default port ---
set "PORT=8866"

REM --- Check if default port is in use ---
netstat -ano | find ":%PORT%" >nul
if %errorlevel%==0 (
    echo Port %PORT% is already in use. Finding another port...
    for /f %%P in ('powershell -Command "Get-Random -Minimum 1025 -Maximum 65535"') do set PORT=%%P
)

set "URL=http://localhost:%PORT%"

echo.
echo ------------------------------------------
echo Launching Voila Dashboard:
echo     !selected!
echo Accessible at:
echo     %URL%
echo ------------------------------------------
echo.

REM --- Launch Voilà ---
REM Optional: add --static-path=static if you have a favicon.ico in a 'static' folder
"%PYTHON_EXE%" -m voila "!selected!" --port=%PORT% --strip_sources=True

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Voila failed to start.
    echo Please ensure crash_daddy was unpacked correctly.
)

echo.
pause