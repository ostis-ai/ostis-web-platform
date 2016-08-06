@echo off
cd /d %~dp0
cmd /c powershell -ExecutionPolicy Bypass .\bootstrap-stage1.ps1
