@echo off
rem Needs Windows and Git installed
rem 6 naming possibilities tested:
rem decenc enc tfile
rem decenc enc tfile.txt
rem decenc enc "tfile"
rem decenc enc "tfile.txt"
rem decenc enc "tfile aa"
rem decenc enc "tfile aa.txt"

rem CALL :dequote srcfile
rem CALL :dequote destfile
rem echo %srcfile%
rem echo %destfile%
rem goto :EOF
rem pause
set srcfile="%2"
@rem if no pass is given ask for one
rem echo on
set pass=
if NOT "%3" EQU "" set pass="%3"
if "%3" EQU "" SET /p pass="Type password:  "
if "%pass%" EQU "" echo using default!
if "%pass%" EQU "" SET pass=123

if "%1" EQU "enc" GOTO enc
if "%1" EQU "dec" GOTO dec
GOTO :EOF

:enc
rem echo on
@rem twice in case of ""file aaa""
for /f "delims=" %%A in ('echo %%srcfile%%') do set srcfile=%%~A
for /f "delims=" %%A in ('echo %%srcfile%%') do set srcfile=%%~A
for /f "delims=" %%A in ('echo %%pass%%') do set pass=%%~A
rem for /f "delims=" %%A in ('echo %%destfile%%') do set destfile=%%~A
set destfile=%srcfile%.enc
rem echo %srcfile%
rem echo %destfile%
rem pause
type "%srcfile%" | "C:\Program Files\Git\usr\bin\openssl.exe" aes-256-cbc -base64 -salt -pbkdf2 -pass "pass:%pass%" > "%destfile%"
rem pause
@rem "C:\Program Files\Git\usr\bin\openssl.exe" aes-256-cbc -base64 -salt -pbkdf2 -in '%srcfile%' -out '%destfile%' -pass "pass:123"
IF NOT "%destfile%" EQU "%srcfile%" if EXIST "%destfile%" del "%srcfile%"
GOTO :EOF

:dec
@rem twice in case of ""file aaa""
for /f "delims=" %%A in ('echo %%srcfile%%') do set srcfile=%%~A
for /f "delims=" %%A in ('echo %%srcfile%%') do set srcfile=%%~A
for /f "delims=" %%A in ('echo %%pass%%') do set pass=%%~A
rem for /f "delims=" %%A in ('echo %%destfile%%') do set destfile=%%~A
set destfile=%srcfile:~0,-4%

rem echo on
type "%srcfile%" | "C:\Program Files\Git\usr\bin\openssl.exe" aes-256-cbc -base64 -d -salt -pbkdf2 -pass "pass:%pass%" > "%destfile%"
@rem "C:\Program Files\Git\usr\bin\openssl.exe" aes-256-cbc -base64 -d -salt -pbkdf2 -in '%srcfile%' -out '%destfile%' -pass "pass:123"
IF NOT "%destfile%" EQU "%srcfile%" if EXIST "%destfile%" del "%srcfile%"
GOTO :EOF



:DeQuote
for /f "delims=" %%A in ('echo %%%1%%') do set %1=%%~A
Goto :eof