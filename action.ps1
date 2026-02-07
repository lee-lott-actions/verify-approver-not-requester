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
      Write-Host "Verification passed: Approver '$Approver' is different from requester '$Requester'."
    } else {      
      Add-Content -Path $env:GITHUB_OUTPUT -Value "result=success"
      Add-Content -Path $env:GITHUB_OUTPUT -Value "is-approver-not-requester=false"    
	  Write-Host "Verification failed: Approver '$Approver' cannot be the same as the requester '$Requester'."
    }
  } catch {
	  $errorMsg = "Error: Failed to verify requester '$Requester' is not approver '$Approver'. Exception: $($_.Exception.Message)"
      Add-Content -Path $env:GITHUB_OUTPUT -Value "result=failure"
      Add-Content -Path $env:GITHUB_OUTPUT -Value "is-approver-not-requester=false"    
	  Add-Content -Path $env:GITHUB_OUTPUT -Value "error-message=$errorMsg"    
	  Write-Host $errorMsg
  }
}
