# Change the color of the prompt text
$host.UI.RawUI.ForegroundColor = 'Cyan'

# Prompt user for the permission string
$permissionToFind = Read-Host "Enter the permission string you're looking for"

# Reset the color back to default
$host.UI.RawUI.ForegroundColor = 'White'  # Or use your desired default color

# Ask user whether to display full actions list or short (template-matching) actions list
$actionChoice = Read-Host "Do you want to display the full actions list or only short (template-matching) actions list? (Type 'full' or 'short')"

# Set default value to 'short' if no input is provided
if (-not $actionChoice) {
  $actionChoice = 'short'
}

# Get all role definitions
$roles = Get-AzRoleDefinition

# Variables to hold the two groups
$exactMatches = @()
$templateMatches = @()

# Check each role's permissions for the specified permission string
foreach ($role in $roles) {
  $actions = $role.Actions

  # Separate exact matches and template matches (case-insensitive based on input case)
  $exactMatch = $actions | Where-Object { $_ -ieq $permissionToFind }
  $templateMatch = $actions | Where-Object { $_ -like "$($permissionToFind.Split('/')[0])*" -and $_ -ne $permissionToFind }

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
      # Capitalize the exact match and display it in Yellow
      if ($_ -ieq $permissionToFind) {
        Write-Host "  - $($_.ToUpper())" -ForegroundColor Green  # Capitalized matching action
      }
      else {
        Write-Host "  - $_" -ForegroundColor Yellow  # Keep non-matching actions as they are
      }
    }
    Write-Host "====================" -ForegroundColor Cyan
  }
}
else {
  Write-Host "`nNo roles found with the exact permission." -ForegroundColor Red
}

# Display the results for template matches
if ($templateMatches.Count -gt 0) {
  Write-Host "`n==================== Template Matches ====================" -ForegroundColor Cyan
  foreach ($role in $templateMatches) {
    Write-Host "Role: $($role.Name)" -ForegroundColor Magenta
    Write-Host "Actions:"

    # Check user choice and display actions accordingly
    if ($actionChoice -eq 'full') {
      # Display all actions for the role
      $role.Actions | ForEach-Object {
        # Capitalize the exact match and display it in Yellow
        if ($_ -ieq $permissionToFind) {
          Write-Host "  - $($_.ToUpper())" -ForegroundColor Yellow  # Capitalized matching action
        }
        else {
          Write-Host "  - $_" -ForegroundColor Green  # Keep non-matching actions as they are
        }
      }
    }
    elseif ($actionChoice -eq 'short') {
      # Display only template-matching actions
      $role.Actions | Where-Object { $_ -like "$($permissionToFind.Split('/')[0])*" -and $_ -ne $permissionToFind } | ForEach-Object {
        # Capitalize the exact match and display it in Yellow
        if ($_ -ieq $permissionToFind) {
          Write-Host "  - $($_.ToUpper())" -ForegroundColor Yellow  # Capitalized matching action
        }
        else {
          Write-Host "  - $_" -ForegroundColor Green  # Keep non-matching actions as they are
        }
      }
    }
    else {
      Write-Host "Invalid choice. Please enter 'full' or 'short'." -ForegroundColor Red
    }
    
    Write-Host "====================" -ForegroundColor Cyan
  }
}
else {
  Write-Host "`nNo roles found with template matches." -ForegroundColor Red
}
