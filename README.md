# Azure DevOps Automation with PowerShell
This repository provides PowerShell scripts for automating various tasks in Azure DevOps, alongside pipeline configurations that utilize these scripts to enhance CI/CD workflows.

## Key Scripts
- BackupAndDeletePackages.ps1: Automates the backup and deletion of nuget packages to manage storage.
- CheckWorkItemsStatusandMoveAfterPR.ps1: Verifies the status of work items and moves them after pull requests are completed.
- moveWorkItemsAfterDeploy.ps1: Moves work items post-deployment based on their status.
- removeRetentionLeases.ps1: Removes old retention leases to free up resources and remove unused pipelines.


