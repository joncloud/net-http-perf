Function New-DotNetPublish($App, $Configuration) {
    $SourcePath = Join-Path ./ $App
    Push-Location $SourcePath

    $TargetPath = Join-Path ../bin $App
    If (Test-Path $TargetPath) {
        Remove-Item -Recurse -Force $TargetPath
    }
    dotnet publish --configuration $Configuration --output $TargetPath
    Pop-Location
}

Function Start-Reflector($Port) {
    $Urls = "http://127.0.0.1:$Port"
    Write-Host "Starting Reflector $Urls"
    $Process = Start-Process powershell.exe `
        -WorkingDirectory (Resolve-Path .).Path `
        -PassThru `
        -ArgumentList "&{ `$env:ASPNETCORE_URLS='$Urls'; dotnet ./bin/Reflector/Reflector.dll }"
        
    $Process
}

Function Invoke-Test($Name, $Block) {
    $CoreReflector = Start-Reflector 5020
    $FrameworkReflector = Start-Reflector 5461

    $Block.Invoke()

    $CoreReflector.Kill()
    $FrameworkReflector.Kill()

    $TargetPath = "./results/$Name.md"
    Write-Host "######### $Name"
    Move-Item ./BenchmarkDotNet.Artifacts/results/Program-report-github.md $TargetPath
    Get-Content $TargetPath
}

Push-Location $PSScriptRoot
dotnet restore

New-DotNetPublish App.Net461 release
New-DotNetPublish App.NetCoreApp20 release
New-DotNetPublish Reflector release

$Timestamp = (Get-Date).Ticks
New-Item ./results -ItemType Directory -ErrorAction SilentlyContinue

If (Test-Path ./BenchmarkDotNet.Artifacts) {
    Remove-Item -Recurse -Force ./BenchmarkDotNet.Artifacts
}

Invoke-Test "$Timestamp-Net461" {
    ./bin/App.Net461/App.Net461.exe | Out-Null
}
Invoke-Test "$Timestamp-NetCoreApp20" {
    dotnet ./bin/App.NetCoreApp20/App.NetCoreApp20.dll | Out-Null
}

Pop-Location