# GatherTrail - envia (com a sua confirmacao) os pontos de spawn que voce confirmou.
# Le o seu SavedVariables, junta so as chaves "mapa:item:x:y" (nenhum dado pessoal) e abre
# uma pagina de "nova issue" no GitHub ja preenchida. Voce revisa e clica em Submit.
$addon = $PSScriptRoot
$wtf = Join-Path $addon '..\..\..\WTF\Account'
$files = Get-ChildItem -Path $wtf -Recurse -Filter '*.lua' -ErrorAction SilentlyContinue |
    Where-Object { $_.DirectoryName -like '*SavedVariables' -and $_.BaseName -in @('Trailsmith','GatherTrail') }
$keys = @()
foreach ($f in $files) {
    $text = Get-Content $f.FullName -Raw
    foreach ($m in [regex]::Matches($text, '\["key"\] = "(\d+:\d+:\d+:\d+)"')) { $keys += $m.Groups[1].Value }
}
$keys = @($keys | Sort-Object -Unique)
$sentFile = Join-Path $addon 'contribute_sent.txt'
$sent = @()
if (Test-Path $sentFile) { $sent = @(Get-Content $sentFile) }
$new = @($keys | Where-Object { $sent -notcontains $_ })
if ($new.Count -eq 0) {
    Write-Host 'Nenhum ponto novo para enviar. (Os dados so sao gravados no disco ao dar /reload ou sair do jogo.)'
    exit 0
}
$batch = @($new | Select-Object -First 100)
Write-Host ("{0} pontos confirmados novos. Vou abrir o GitHub com {1} deles." -f $new.Count, $batch.Count)
Write-Host 'O texto contem apenas numeros (mapa, item, x, y). A issue sera publicada com a sua conta do GitHub.'
$ans = Read-Host 'Abrir agora? (S/N)'
if ($ans -notmatch '^[sSyY]') { exit 0 }
$body = "GatherTrail confirmation batch`n`n" + ($batch -join "`n")
$url = 'https://github.com/cleytoncl3/GatherTrail/issues/new?title=' +
    [uri]::EscapeDataString('GatherTrail confirmation') + '&body=' + [uri]::EscapeDataString($body)
Start-Process $url
Add-Content -Path $sentFile -Value $batch
Write-Host 'Pronto. Clique em "Submit new issue" na pagina. Rode de novo para enviar o resto.'
