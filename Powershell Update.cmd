@echo off
:: Verifica se lo script è in esecuzione come amministratore
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Lo script richiede i privilegi di amministratore. Riavvio come amministratore...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Verifica se winget è disponibile
winget -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Winget non è disponibile. Aggiorna il sistema o installa Winget prima di procedere.
    exit /b
)

:: Verifica la connessione internet
echo Verifica della connessione internet...
ping -n 1 www.google.com >nul 2>&1
if %errorlevel% neq 0 (
    echo Connessione internet non disponibile. Verifica la tua connessione e riprova.
    exit /b
)

:: Reimposta le fonti di winget per evitare problemi di cache
echo Reimpostazione delle fonti di winget...
winget source reset --force >nul 2>&1
winget source update >nul 2>&1

:: Installa PowerShell direttamente senza ricerca
echo Installazione di PowerShell in corso...
winget install --id Microsoft.PowerShell --source winget --silent --accept-package-agreements --accept-source-agreements
if %errorlevel% neq 0 (
    echo Errore durante l'installazione di PowerShell. Prova a disabilitare temporaneamente il firewall o l'antivirus.
) else (
    echo PowerShell è stato installato con successo.
)
