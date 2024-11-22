$host.UI.RawUI.ForegroundColor = 'Cyan'
$roleToFind = Read-Host "Enter the role"
$host.UI.RawUI.ForegroundColor = 'White'
$roles = Get-AzRoleDefinition
$found = $false

foreach ($role in $roles) {
  if ($role.Name -ieq $roleToFind) {
    Write-Host "LIST OF ACTIONS: " -ForegroundColor Yellow
    foreach ($action in $role.Actions) {
      Write-Host $action -ForegroundColor Green
    }
    Write-Host "LIST OF NOT_ACTIONS: " -ForegroundColor Yellow
    foreach ($notaction in $role.NotActions) {
      Write-Host $notaction -ForegroundColor Green
    }
    Write-Host "LIST OF DATA_ACTIONS: " -ForegroundColor Yellow
    foreach ($dataaction in $role.DataActions) {
      Write-Host $dataaction -ForegroundColor Green
    }
    Write-Host "LIST OF NOT_DATA_ACTIONS: " -ForegroundColor Yellow
    foreach ($notdataaction in $role.NotDataActions) {
      Write-Host $notdataaction -ForegroundColor Green
    }
    $found = $true
    break
  }   
}
if (-not $found) {
  Write-Host "ROLE NOT FOUND" -ForegroundColor Red
}
