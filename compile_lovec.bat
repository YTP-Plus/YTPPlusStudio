@echo off
:drag and drop .love files onto this
copy /b "C:\Program Files\LOVE\lovec.exe"+%1 "%~n1.exe"