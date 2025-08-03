#!/usr/bin/env bats

# Load the Bash script
load ../action.sh

# Setup function to run before each test
setup() {
  export GITHUB_OUTPUT=$(mktemp)
}

# Teardown function to clean up after each test
teardown() {
  rm -f "$GITHUB_OUTPUT"
}

@test "verify_approver_not_requestor succeeds with different requester and approver" {
  run verify_approver_not_requestor "user1" "user2"

  [ "$status" -eq 0 ]
  [ "$(grep 'result' "$GITHUB_OUTPUT")" == "result=success" ]
  [ "$(grep 'is-approver-not-requester' "$GITHUB_OUTPUT")" == "is-approver-not-requester=true" ]
}

@test "verify_approver_not_requestor fails when requester and approver are the same" {
  run verify_approver_not_requestor "user1" "user1"

  [ "$status" -eq 0 ]
  [ "$(grep 'result' "$GITHUB_OUTPUT")" == "result=success" ]
  [ "$(grep 'is-approver-not-requester' "$GITHUB_OUTPUT")" == "is-approver-not-requester=false" ]
}

@test "verify_approver_not_requestor fails with empty requester" {
  run verify_approver_not_requestor "" "user2"

  [ "$status" -eq 0 ]
  [ "$(grep 'result' "$GITHUB_OUTPUT")" == "result=failure" ]
  [ "$(grep 'error-message' "$GITHUB_OUTPUT")" == "error-message=Missing required parameters for verification." ]
}

@test "verify_approver_not_requestor fails with empty approver" {
  run verify_approver_not_requestor "user1" ""

  [ "$status" -eq 0 ]
  [ "$(grep 'result' "$GITHUB_OUTPUT")" == "result=failure" ]
  [ "$(grep 'error-message' "$GITHUB_OUTPUT")" == "error-message=Missing required parameters for verification." ]
}

@test "verify_approver_not_requestor fails with both parameters empty" {
  run verify_approver_not_requestor "" ""

  [ "$status" -eq 0 ]
  [ "$(grep 'result' "$GITHUB_OUTPUT")" == "result=failure" ]
  [ "$(grep 'error-message' "$GITHUB_OUTPUT")" == "error-message=Missing required parameters for verification." ]
}
