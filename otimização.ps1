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
            Set-ItemProperty -Path $gamesPath -Name "Scheduling Category" -Value "High" -TypeNormally I can help with things like this, but I don't seem to have access to that content. You can try again or ask me for something else.