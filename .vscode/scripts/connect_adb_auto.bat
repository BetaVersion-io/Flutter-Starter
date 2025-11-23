@echo off
echo Detecting device IP address...

:: Check if device is connected via USB
adb devices | findstr /R "device$" >nul 2>&1
if errorlevel 1 (
    echo ERROR: No device connected via USB!
    echo Please connect your phone via USB first.
    exit /b 1
)

:: Get device IP address using a simpler approach
for /f "tokens=*" %%i in ('adb shell "ip route | grep wlan0 | grep src | head -1"') do (
    for /f "tokens=9" %%j in ("%%i") do set DEVICE_IP=%%j
)

:: Alternative method if the first one fails
if "%DEVICE_IP%"=="" (
    for /f "tokens=*" %%i in ('adb shell "ifconfig wlan0 2>nul | grep inet | head -1"') do (
        for /f "tokens=2" %%j in ("%%i") do (
            for /f "tokens=2 delims=:" %%k in ("%%j") do set DEVICE_IP=%%k
        )
    )
)

:: Another alternative using ip addr
if "%DEVICE_IP%"=="" (
    for /f "tokens=*" %%i in ('adb shell "ip -4 addr show wlan0 | grep inet"') do (
        for /f "tokens=2" %%j in ("%%i") do (
            for /f "tokens=1 delims=/" %%k in ("%%j") do set DEVICE_IP=%%k
        )
    )
)

:: Check if we got an IP
if "%DEVICE_IP%"=="" (
    echo ERROR: Could not detect device IP address!
    echo Make sure:
    echo   1. WiFi is enabled on your phone
    echo   2. Phone is connected to the same network as your PC
    echo   3. USB debugging is enabled
    exit /b 1
)

echo Found device IP: %DEVICE_IP%
echo Enabling wireless debugging...
adb tcpip 5555
timeout /t 3 /nobreak >nul

echo Connecting to %DEVICE_IP%:5555...
adb connect %DEVICE_IP%:5555
timeout /t 1 /nobreak >nul

echo.
echo Connected devices:
adb devices
echo.
echo You can now disconnect the USB cable!