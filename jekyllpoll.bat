REM start ruby -run -e httpd _site -p4000
REM :loop
REM start /WAIT /B jekyll build
REM timeout 1 > nul
REM goto loop

:loop
start jekyll build
taskkill /F /IM ruby.exe /T
start ruby -run -e httpd _site -p4000
timeout /t 5
goto loop