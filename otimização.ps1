# -------------------------------------------------------------------------
# SCRIPT DE OTIMIZAÇÃO (BASEADO NO TUTORIAL DO IGUST)
# Execute sempre como Administrador!
# -------------------------------------------------------------------------

# Configuração de cores para o tema Roxo
$corMenu = "Magenta"
$corTexto = "White"
$corSucesso = "Green"
$corAviso = "Yellow"

function Mostrar-Cabecalho {
    Clear-Host
    Write-Host "=========================================================" -ForegroundColor $corMenu
    Write-Host "         SISTEMA DE OTIMIZAÇÃO DO WINDOWS (iGust)         " -ForegroundColor $corTexto -BackgroundColor $corMenu
    Write-Host "=========================================================" -ForegroundColor $corMenu
    Write-Host ""
}

# Caminhos do Registro
$sysProfile = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
$gamesPath  = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
$dataColl   = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
$gameDvrPol = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
$explorerPol = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"

while ($true) {
    Mostrar-Cabecalho
    Write-Host " [1] Otimizar o Windows (Desempenho & FPS)" -ForegroundColor $corTexto
    Write-Host " [2] Reverter Otimização (Padrão do Windows)" -ForegroundColor $corTexto
    Write-Host " [3] Sair" -ForegroundColor $corTexto
    Write-Host ""
    Write-Host "=========================================================" -ForegroundColor $corMenu
    
    $opcao = Read-Host "Escolha uma opção (1-3)"

    switch ($opcao) {
        "1" {
            Mostrar-Cabecalho
            Write-Host "=> Aplicando otimizações..." -ForegroundColor $corMenu

            # 1. Compressão de Memória
            Write-Host "[-] Desativando compressão de memória..." -ForegroundColor $corTexto
            Disable-MMAgent -mc 2>$null

            # 2. Plano de Energia
            Write-Host "[-] Habilitando plano de Desempenho Máximo..." -ForegroundColor $corTexto
            powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null

            # 3. SystemProfile (Responsividade e Rede)
            Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 10 -Type DWord -Force
            Set-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force

            # 4. Prioridades de Jogos (CPU e GPU)
            Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 6 -Type DWord -Force
            Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "High" -Type String -Force
            Set-ItemProperty -Path $gamesPath -Name "SFIO Priority" -Value "High" -Type String -Force

            # 5. Telemetria
            if (!(Test-Path $dataColl)) { New-Item -Path $dataColl -Force | Out-Null }
            Set-ItemProperty -Path $dataColl -Name "AllowTelemetry" -Value 0 -Type DWord -Force

            # 6. Game DVR e Xbox
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 0 -Type DWord -Force
            if (!(Test-Path $gameDvrPol)) { New-Item -Path $gameDvrPol -Force | Out-Null }
            Set-ItemProperty -Path $gameDvrPol -Name "AllowGameDVR" -Value 0 -Type DWord -Force

            # 7. Pesquisa do Menu Iniciar (Bing/Cortana)
            if (!(Test-Path $explorerPol)) { New-Item -Path $explorerPol -Force | Out-Null }
            Set-ItemProperty -Path $explorerPol -Name "DisableSearchBoxSuggestions" -Value 1 -Type DWord -Force
            Set-ItemProperty -Path $explorerPol -Name "CortanaConsent" -Value 0 -Type DWord -Force
            Set-ItemProperty -Path $explorerPol -Name "BingSearchEnabled" -Value 0 -Type DWord -Force

            Write-Host ""
            Write-Host "Otimizações aplicadas com sucesso! Reinicie o computador." -ForegroundColor $corSucesso
            pause
        }
        "2" {
            Mostrar-Cabecalho
            Write-Host "=> Revertendo para as configurações padrão..." -ForegroundColor $corMenu

            # 1. Reativar compressão de memória
            Enable-MMAgent -mc 2>$null

            # 2. Voltar SystemProfile ao padrão
            Set-ItemProperty -Path $sysProfile -Name "SystemResponsiveness" -Value 20 -Type DWord -Force
            Remove-ItemProperty -Path $sysProfile -Name "NetworkThrottlingIndex" -ErrorAction SilentlyContinue

            # 3. Voltar prioridades de jogos ao padrão
            Set-ItemProperty -Path $gamesPath -Name "Priority" -Value 2 -Type DWord -Force
            Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "Medium" -Type String -Force
            Set-ItemProperty -Path $gamesPath -Name "SFIO Priority" -Value "Normal" -Type String -Force

            # 4. Remover políticas adicionadas
            Remove-ItemProperty -Path $dataColl -Name "AllowTelemetry" -ErrorAction SilentlyContinue
            Set-ItemProperty -Path "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -Type DWord -Force
            Remove-ItemProperty -Path $gameDvrPol -Name "AllowGameDVR" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $explorerPol -Name "DisableSearchBoxSuggestions" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $explorerPol -Name "CortanaConsent" -ErrorAction SilentlyContinue
            Remove-ItemProperty -Path $explorerPol -Name "BingSearchEnabled" -ErrorAction SilentlyContinue

            Write-Host ""
            Write-Host "Configurações restauradas para o padrão! Reinicie o computador." -ForegroundColor $corSucesso
            pause
        }
        "3" {
            exit
        }
    }
}
