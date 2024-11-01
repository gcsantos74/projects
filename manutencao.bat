@echo off
cls
title= manutencao

:: Verifica se está executando como administrador e muda para administrador
NET SESSION >nul 2>&1
if %errorlevel% neq 0 (
    echo Executando como Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /B
)

set "color_file=config.txt"

rem Verifica se o arquivo de configuração existe
if exist "%color_file%" (

rem Lê a cor do arquivo
    set /p cor=<"%color_file%"
    color %cor%
) else (
    goto menu
)

:menu
cls
echo.
echo ====================================
echo              MENU
echo ====================================
echo.
echo 1. Verificar integridade do sistema
echo 2. Verificar disco
echo 3. Informacoes de rede
echo 4. Backup de pasta
echo 5. Limpar arquivos temporarios
echo 6. Desligar o computador
echo 7. Gerenciador de Tarefas
echo 8. Agendador de Tarefas
echo 9. DirectX
echo 10. Ver log de eventos
echo 11. Informacoes do sistema
echo 12. Atualizar programas
echo 13. Alterar a cor do prompt
echo 14. Sair
echo.
echo ====================================
set /p opcao=Digite a opcao desejada: 

if %opcao%==1 goto sfc
if %opcao%==2 goto chkdsk
if %opcao%==3 goto rede
if %opcao%==4 goto backup
if %opcao%==5 goto limpar
if %opcao%==6 goto desligar
if %opcao%==7 goto gerenciador
if %opcao%==8 goto agendador
if %opcao%==9 goto directx
if %opcao%==10 goto eventos
if %opcao%==11 goto info
if %opcao%==12 goto update
if %opcao%==13 goto cor
if %opcao%==14 goto fim

:sfc
cls
echo ====================================
echo.
echo verificando...
sfc /scannow
echo.
echo ====================================
echo verificacao concluida!
echo ====================================
pause
goto menu

:chkdsk
cls
echo ====================================
echo.
chkdsk /f /r
echo.
echo ====================================
echo verificacao de disco concluida!
echo ====================================
pause
goto menu

:rede
cls
echo ====================================
echo.

if not exist %userprofile%\Desktop\manutencao\relatorio md %userprofile%\Desktop\manutencao\relatorio

ipconfig > %userprofile%\Desktop\manutencao\relatorio\ipconfig.txt
echo arquivo criado em : \Desktop\manutencao\relatorio\ipconfig.txt
echo. >> %userprofile%\Desktop\manutencao\relatorio\ipconfig.txt
echo Nome do computador: %computername% >> %userprofile%\Desktop\manutencao\relatorio\ipconfig.txt
echo Data e hora: %date% %time% >> %userprofile%\Desktop\manutencao\relatorio\ipconfig.txt

echo.
echo ===================================
echo.
pause
goto menu

:backup
cls
set "pasta_file=pasta.txt"

if exist "%pasta_file%" (
    set /p pasta=<"%pasta_file%"
)
if not defined pasta (
    echo Digite o caminho completo da pasta a ser copiada: 
    set /p pasta=
    echo %pasta% > "%pasta_file%"
) else (
    echo Usando a pasta previamente definida: %pasta%
)

set /p continuar="Deseja fazer outro backup com o mesmo diretorio? (s/n): "

if /i "%continuar%"=="s" (
xcopy %pasta% %userprofile%\Desktop\manutencao\backup /s /e /h
echo Backup concluido!
pause

    goto menu
) else (
    set pasta=
    del "%pasta_file%"
	pause 
	goto menu
)

:limpar
cls
echo =============================================
echo iniciando a limpeza dos arquivos temporarios
echo =============================================
del /s /q %temp%\*
del /s /q %userprofile%\AppData\Local\Temp\*
echo.
echo ==========================================
echo Limpeza concluida!
echo ==========================================
pause
goto menu

:desligar
cls
echo ===================================================
echo.
set /p continuar="Deseja desligar o computador? (s/n): "
echo.
echo ===================================================
if /i "%continuar%"=="s"(
shutdown -s -t 5)
else(
goto menu
)

:gerenciador
cls
echo ==========================================
echo.
echo iniciando...
taskmgr
echo.
echo ==========================================
pause
goto menu

:agendador
cls
echo ==========================================
echo.
echo iniciando...
echo.
echo ==========================================
taskschd.msc
pause
goto menu

:directx
echo ==========================================
echo.
echo iniciando...
dxdiag
echo.
echo ==========================================
pause
goto menu

:eventos
cls
echo ==========================================
echo.
echo iniciando...
eventvwr
echo.
echo ==========================================
pause
goto menu

:info
cls
echo ======================
echo.
echo iniciando...
systeminfo
echo.
echo ======================
pause
goto menu

:update
cls
echo ==========================================
echo.
echo atualizando todos programas para a versão mais recente
echo.
echo ==========================================
winget upgrade --all
echo.
pause
goto menu

:cor

echo 0 = Preto        8 = Cinza
echo 1 = Azul         9 = Azul claro
echo 2 = Verde        A = Verde claro
echo 3 = Verde-água   B = Verde-água claro
echo 4 = Vermelho     C = Vermelho claro
echo 5 = Roxo         D = Lilás
echo 6 = Amarelo      E = Amarelo claro
echo 7 = Branco       F = Branco brilhante
set /p user_color="Digite a cor: 

if /i "%user_color%" geq "0" if /i "%user_color%" leq "F" (

::Salva a cor no arquivo
	echo %user_color% > %color_file%
	
    color %user_color%
	pause
	goto menu
) else (
    echo Entrada inválida.
	goto cor
)

pause
goto menu

:fim
echo Saindo...


