$host.UI.RawUI.ForegroundColor = 'Cyan'
$permissionToFind = Read-Host "Enter the permission string you're looking for"
$host.UI.RawUI.ForegroundColor = 'White' 
$actionChoice = Read-Host "Do you want to display the full actions list or only short (template-matching) actions list? (Type 'full' or 'short')"

if (-not $actionChoice) {
  $actionChoice = 'short'
}

$roles = Get-AzRoleDefinition
$exactMatches = @()
$templateMatches = @()

foreach ($role in $roles) {
  $actions = $role.Actions
  $exactMatch = $actions | Where-Object { $_ -ieq $permissionToFind }
  $templateMatch = $actions | Where-Object { $_ -like "$($permissionToFind.Split('/')[0])*" -and $_ -ne $permissionToFind }

  if ($exactMatch) {
    $exactMatches += $role
  }

  if ($templateMatch) {
    $templateMatches += $role
  }
}

if ($exactMatches.Count -gt 0) {
  Write-Host "`n==================== Exact Matches ====================" -ForegroundColor Cyan
  foreach ($role in $exactMatches) {
    Write-Host "Role: $($role.Name)" -ForegroundColor Magenta
    Write-Host "Actions:"
    $role.Actions | ForEach-Object {
      if ($_ -ieq $permissionToFind) {
        Write-Host "  - $_" -ForegroundColor Green  
      }
      elseif ($actionChoice -eq "full") {
        Write-Host "  - $_" -ForegroundColor Yellow
      }
    }
    Write-Host "====================" -ForegroundColor Cyan
  }
}
else {
  Write-Host "`nNo roles found with the exact permission." -ForegroundColor Red
}

# Display the results for template matches
# if ($templateMatches.Count -gt 0) {
#   Write-Host "`n==================== Template Matches ====================" -ForegroundColor Cyan
#   foreach ($role in $templateMatches) {
#     Write-Host "Role: $($role.Name)" -ForegroundColor Magenta
#     Write-Host "Actions:"

#     # Check user choice and display actions accordingly
#     if ($actionChoice -eq 'short') {
#       # Display all actions for the role
#       $role.Actions | ForEach-Object {
#         # Capitalize the exact match and display it in Yellow
#         if ($_ -like "$($permissionToFind.Split('/')[0])*") {
#           Write-Host "  - $_" -ForegroundColor Yellow  # Capitalized matching action
#         }
#         # else {
#         #   Write-Host "  - $_" -ForegroundColor Yellow  # Keep non-matching actions as they are
#         # }
#       }
#     }
#     # elseif ($actionChoice -eq 'short') {
#     #   # Display only template-matching actions
#     #   $role.Actions | Where-Object { $_ -like "$($permissionToFind.Split('/')[0])*" -and $_ -ne $permissionToFind } | ForEach-Object {
#     #     # Capitalize the exact match and display it in Yellow
#     #     if ($_ -ieq $permissionToFind) {
#     #       Write-Host "  - $($_.ToUpper())" -ForegroundColor Green  # Capitalized matching action
#     #     }
#     #     else {
#     #       Write-Host "  - $_" -ForegroundColor Yellow  # Keep non-matching actions as they are
#     #     }
#     #   }
#     # }
#     else {
#       Write-Host "Invalid choice. Please enter 'full' or 'short'." -ForegroundColor Red
#     }
    
#     Write-Host "====================" -ForegroundColor Cyan
#   }
# }
# else {
#   Write-Host "`nNo roles found with template matches." -ForegroundColor Red
# }
