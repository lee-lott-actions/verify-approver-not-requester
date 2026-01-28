BeforeAll {
  # Load the PowerShell script
  . "$PSScriptRoot/../action.ps1"
}

Describe "Verify-ApproverNotRequestor" {
  BeforeEach {
    # Setup function to run before each test
    $env:GITHUB_OUTPUT = [System.IO.Path]::GetTempFileName()
  }

  AfterEach {
    # Teardown function to clean up after each test
    if (Test-Path $env:GITHUB_OUTPUT) {
      Remove-Item $env:GITHUB_OUTPUT -Force
    }
  }

  It "succeeds with different requester and approver" {
    Verify-ApproverNotRequestor -Requester "user1" -Approver "user2"
    
    $output = Get-Content $env:GITHUB_OUTPUT
    $output | Should -Contain "result=success"
    $output | Should -Contain "is-approver-not-requester=true"
  }

  It "fails when requester and approver are the same" {
    Verify-ApproverNotRequestor -Requester "user1" -Approver "user1"
    
    $output = Get-Content $env:GITHUB_OUTPUT
    $output | Should -Contain "result=success"
    $output | Should -Contain "is-approver-not-requester=false"
  }

  It "fails with empty requester" {
    Verify-ApproverNotRequestor -Requester "" -Approver "user2"
    
    $output = Get-Content $env:GITHUB_OUTPUT
    $output | Should -Contain "result=failure"
    $output | Should -Contain "error-message=Missing required parameters for verification."
  }

  It "fails with empty approver" {
    Verify-ApproverNotRequestor -Requester "user1" -Approver ""
    
    $output = Get-Content $env:GITHUB_OUTPUT
    $output | Should -Contain "result=failure"
    $output | Should -Contain "error-message=Missing required parameters for verification."
  }

  It "fails with both parameters empty" {
    Verify-ApproverNotRequestor -Requester "" -Approver ""
    
    $output = Get-Content $env:GITHUB_OUTPUT
    $output | Should -Contain "result=failure"
    $output | Should -Contain "error-message=Missing required parameters for verification."
  }
}
