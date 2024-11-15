# Set console colors
$host.UI.RawUI.ForegroundColor = 'Cyan'
$permissionToFind = Read-Host "Enter the permission string you're looking for"
$host.UI.RawUI.ForegroundColor = 'White'

# Fetch all Azure role definitions
$roles = Get-AzRoleDefinition
$exactMatches = @()
$templateMatches = @()

# Extract the base part of the permission string for wildcard match
$basePermission = $permissionToFind -replace '/\*$', ''  # Remove trailing '*' if present
$permissionPattern = "$basePermission/*"

# Loop through each role and check for exact and template matches
foreach ($role in $roles) {
  $actions = $role.Actions

  # Exact match check
  $exactMatch = $actions | Where-Object { $_ -ieq $permissionToFind }

  # Template match check
  $templateMatch = $actions | Where-Object {
        ($_ -eq $permissionPattern) -or ($_ -like "$permissionToFind/*")
  }

  # Collect roles based on match type
  if ($exactMatch) {
    $exactMatches += $role
  }
  if ($templateMatch) {
    $templateMatches += $role
  }
}

# Display the results for exact matches
if ($exactMatches.Count -gt 0) {
  Write-Host "`n==================== Exact Matches ====================" -ForegroundColor Cyan
  foreach ($role in $exactMatches) {
    Write-Host "Role: $($role.Name)" -ForegroundColor Magenta
    Write-Host "Actions:"
    $role.Actions | ForEach-Object {
      if ($_ -ieq $permissionToFind) {
        Write-Host "  - $_" -ForegroundColor Green
      }
    }
    Write-Host "====================" -ForegroundColor Cyan
  }
}
else {
  Write-Host "`nNo exact matches found." -ForegroundColor Red
}

# Display the results for template matches
if ($templateMatches.Count -gt 0) {
  Write-Host "`n==================== Template Matches ====================" -ForegroundColor Cyan
  foreach ($role in $templateMatches) {
    Write-Host "Role: $($role.Name)" -ForegroundColor Magenta
    Write-Host "Actions:"
    $role.Actions | ForEach-Object {
      if ($_ -eq $permissionPattern -or $_ -like "$permissionToFind/*") {
        Write-Host "  - $_" -ForegroundColor Yellow
      }
    }
    Write-Host "====================" -ForegroundColor Cyan
  }
}
else {
  Write-Host "`nNo template matches found." -ForegroundColor Red
}
