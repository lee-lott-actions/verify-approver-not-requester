Describe "Verify-ApproverNotRequestor" {
	BeforeAll {
	  # Load the PowerShell script
	  . "$PSScriptRoot/../action.ps1"
	}
	
	BeforeEach {
		$env:GITHUB_OUTPUT = New-TemporaryFile
	}

	AfterEach {
		if (Test-Path $env:GITHUB_OUTPUT) { Remove-Item $env:GITHUB_OUTPUT }
	}

	Context "Verification Cases" {
		It "unit: Verify-ApproverNotRequestor succeeds with different requester and approver" {
			Verify-ApproverNotRequestor -Requester "user1" -Approver "user2"
	
			$output = Get-Content $env:GITHUB_OUTPUT
			$output | Should -Contain "result=success"
			$output | Should -Contain "is-approver-not-requester=true"
		}
	
		It "unit: Verify-ApproverNotRequestor fails when requester and approver are the same" {
			Verify-ApproverNotRequestor -Requester "user1" -Approver "user1"
	
			$output = Get-Content $env:GITHUB_OUTPUT
			$output | Should -Contain "result=success"
			$output | Should -Contain "is-approver-not-requester=false"
		}
	}

	Context "Parameter Validation Failure Cases" {
		It "unit: Verify-ApproverNotRequestor fails with empty requester" {
			Verify-ApproverNotRequestor -Requester "" -Approver "user2"
	
			$output = Get-Content $env:GITHUB_OUTPUT
			$output | Should -Contain "result=failure"
			$output | Should -Contain "error-message=Missing required parameters for verification."
		}
	
		It "unit: Verify-ApproverNotRequestor fails with empty approver" {
			Verify-ApproverNotRequestor -Requester "user1" -Approver ""
	
			$output = Get-Content $env:GITHUB_OUTPUT
			$output | Should -Contain "result=failure"
			$output | Should -Contain "error-message=Missing required parameters for verification."
		}
	
		It "unit: Verify-ApproverNotRequestor fails with both parameters empty" {
			Verify-ApproverNotRequestor -Requester "" -Approver ""
	
			$output = Get-Content $env:GITHUB_OUTPUT
			$output | Should -Contain "result=failure"
			$output | Should -Contain "error-message=Missing required parameters for verification."
		}	
	}

	Context "Exception Failure Cases" {
		It "unit: Verify-ApproverNotRequestor fails with exception" {
			Mock Write-Host {
				param([Parameter(Position=0)][object]$Object)
	
				# Throw only for the Write-Host call inside the try block,
				# not the initial "Verifying..." message (which is outside try/catch).
				if ($Object -like "Verification *") {
					throw "API Error"
				}
			}
			
			Verify-ApproverNotRequestor -Requester "user1" -Approver "user1"
	
			$output = Get-Content $env:GITHUB_OUTPUT
			$output | Should -Contain "result=failure"
			$output | Should -Contain "is-approver-not-requester=false"
			$output | Where-Object { $_ -match "^error-message=Error: Failed to verify requester 'user1' is not approver 'user1'\. Exception:" } |
				Should -Not -BeNullOrEmpty
		}	
	}
}
