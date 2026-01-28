function Verify-ApproverNotRequestor {
  param(
    [string]$Requester,
    [string]$Approver
  )

  Write-Host "Verifying that approver ($Approver) is not the same as requester ($Requester)"

  if ([string]::IsNullOrEmpty($Requester) -or [string]::IsNullOrEmpty($Approver)) {
    Write-Host "Error: REQUESTER and APPROVER must be provided."
    Add-Content -Path $env:GITHUB_OUTPUT -Value "result=failure"
    Add-Content -Path $env:GITHUB_OUTPUT -Value "error-message=Missing required parameters for verification."
    return
  }

  try {
    if ($Requester -ne $Approver) {    
      Add-Content -Path $env:GITHUB_OUTPUT -Value "result=success"
      Add-Content -Path $env:GITHUB_OUTPUT -Value "is-approver-not-requester=true"
      Write-Host "Verification passed: Approver ($Approver) is different from requester ($Requester)."    
    } else {
      Write-Host "Approver ($Approver) cannot be the same as the requester ($Requester)."
      Add-Content -Path $env:GITHUB_OUTPUT -Value "result=success"
      Add-Content -Path $env:GITHUB_OUTPUT -Value "is-approver-not-requester=false"    
    }
  } catch {
      Write-Host "Failed to verify requestor is not approver."
      Add-Content -Path $env:GITHUB_OUTPUT -Value "result=failure"
      Add-Content -Path $env:GITHUB_OUTPUT -Value "is-approver-not-requester=false"    
  }
}
