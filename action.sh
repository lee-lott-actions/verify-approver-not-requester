#!/bin/bash

verify_approver_not_requestor() {
  local requester="$1"
  local approver="$2"

  echo "Verifying that approver ($approver) is not the same as requester ($requester)"

  if [ -z "$requester" ] || [ -z "$approver" ]; then
    echo "Error: REQUESTER and APPROVER must be provided."
    echo "result=failure" >> $GITHUB_OUTPUT
    echo "error-message=Missing required parameters for verification." >> $GITHUB_OUTPUT 
    return
  fi

  if [ "$requester" != "$approver" ]; then    
    echo "result=success" >> $GITHUB_OUTPUT
    echo "is-approver-not-requester=true" >> $GITHUB_OUTPUT
    echo "Verification passed: Approver ($approver) is different from requester ($requester)."    
  else
    echo "Approver ($approver) cannot be the same as the requester ($requester)."
    echo "result=success" >> $GITHUB_OUTPUT
    echo "is-approver-not-requester=false" >> $GITHUB_OUTPUT    
  fi
}

