# Verify Approver Not Requester Action

This GitHub Action verifies that the approver is not the same as the requester by comparing their GitHub usernames. It returns a boolean indicating whether the verification passed and an error message if the verification fails.

## Features
- Checks if the approver and requester usernames are different.
- Outputs a boolean (`result`) to indicate if the verification passed (`true` if different, `false` if same or invalid).
- Provides an error message if the verification fails due to missing inputs or identical users.
- Lightweight and simple, requiring no external API calls.

## Inputs
| Name        | Description                           | Required | Default |
|-------------|---------------------------------------|----------|---------|
| `requester` | The GitHub username of the requester. | Yes      | N/A     |
| `approver`  | The GitHub username of the approver.  | Yes      | N/A     |

## Outputs
| Name           | Description                                                  |
|----------------|--------------------------------------------------------------|
| `result`       | Result of the comparsion of the requester and approver (failure if parameters are emtpy, success otherwise). |
| `is-approver-not-requester`| Boolean indicating if the verification passed (`true` if approver is not requester, `false` otherwise). |
| `error-message`| Error message if the verification fails.                     |

## Usage
1. **Add the Action to Your Workflow**:
   Create or update a workflow file (e.g., `.github/workflows/verify-approver.yml`) in your repository.

2. **Reference the Action**:
   Use the action by referencing the repository and version (e.g., `v1`).

3. **Example Workflow**:
   ```yaml
   name: Verify Approver Not Requester
   on:
     pull_request:
       types: [opened, edited]
   jobs:
     verify-approver:
       runs-on: ubuntu-latest
       steps:
         - name: Verify Approver Not Requester
           id: verify
           uses: lee-lott-actions/verify-approver-not-requester-action@v1.0.0
           with:
             requester: ${{ github.event.pull_request.user.login }}
             approver: ${{ github.event.pull_request.requested_reviewer.login }}
         - name: Print Result
           run: |
             if [[ "${{ steps.verify.outputs.is-approver-not-requester }}" == "true" ]]; then
               echo "Verification passed: Approver is not the requester."
             else
               echo "Error: ${{ steps.verify.outputs.error-message }}"
               exit 1
             fi
