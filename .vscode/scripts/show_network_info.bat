@echo off
echo COMPUTER NETWORK INFO:
echo =====================
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /C:"IPv4"') do echo Computer IP:%%i
echo.

echo PHONE NETWORK INFO:
echo ==================
:: Get phone IP using simple method
for /f "tokens=*" %%i in ('adb shell "ip route | grep wlan0 | grep src | head -1" 2^>nul') do (
    for /f "tokens=9" %%j in ("%%i") do (
        if not "%%j"=="" (
            echo Phone IP: %%j
        ) else (
            echo Phone not connected or WiFi disabled
        )
    )
)

:: If no result, show message
for /f "tokens=*" %%i in ('adb devices ^| findstr /R "device$" 2^>nul') do goto :found
echo Phone not connected or WiFi disabled
:found

echo.
echo ADB DEVICES:
echo ============
adb devices