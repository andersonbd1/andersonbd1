rem https://www.oxhow.com/create-permanently-attach-virtual-hard-disk-windows-7/
@echo off
SET TEMPFILE="%TEMP%%RANDOM%.TXT"
echo SELECT VDISK FILE=E:\g_drive.vhd >%TEMPFILE%
echo ATTACH VDISK>>%TEMPFILE%
DISKPART /s %TEMPFILE%
del %TEMPFILE%
