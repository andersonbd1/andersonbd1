pushd "C:\Program Files (x86)\Mozilla Firefox"
start "" "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -P default
start "" "C:\Program Files (x86)\Mozilla Firefox\firefox.exe" -P dev -no-remote
popd

pushd "C:\dev\cygwin"
start "" C:\dev\cygwin-2\bin\run.exe /usr/bin/bash.exe -l -c "/usr/bin/startxwin.exe -- -emulate3buttons"
popd

pushd "C:\Program Files (x86)\Winamp"
start winamp.exe
popd

rem pushd "C:\dev\java\apache-tomcat-6.0.35\bin"
rem start tomcat6w.exe
rem popd

pushd "C:\dev\andersonbd1\home\vimsessions"
start gvim -S out.vim
start gvim -S scratch.vim
start gvim -S curl.vim

rem pushd "D:\CarswellSearchWeb"
rem start gvim -S search.vim


outlook
rem
rem 
rem 
rem 
rem 

rem 
rem 
rem 

rem 
rem 
rem 

rem 
rem 
rem 
