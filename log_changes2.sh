-- log_changes.sql (SQLcl script with human-readable changelog)
 
accept oldBranch char prompt 'Enter OLD branch/tag: '
accept newBranch char prompt 'Enter NEW branch/tag: '
 
-- Create reports folder
host mkdir reports 2>nul
 
-- Always sync remote
host git fetch --all
 
-- Raw Git outputs
host git diff --name-only &oldBranch &newBranch > reports/files_changed_&oldBranch._to_&newBranch..txt
host git diff --stat &oldBranch &newBranch > reports/summary_&oldBranch._to_&newBranch..txt
host git diff &oldBranch &newBranch > reports/diff_&oldBranch._to_&newBranch..patch
 
-- Human-readable CHANGELOG
host echo "Release &newBranch - End-User Changes" > reports/CHANGELOG_USER_&newBranch..md
host echo. >> reports/CHANGELOG_USER_&newBranch..md
host echo "- Application updated from &oldBranch to &newBranch." >> reports/CHANGELOG_USER_&newBranch..md
host echo "- See summary_&oldBranch._to_&newBranch..txt for technical file-level details." >> reports/CHANGELOG_USER_&newBranch..md
host echo "- Full patch stored in diff_&oldBranch._to_&newBranch..patch" >> reports/CHANGELOG_USER_&newBranch..md
host echo. >> reports/CHANGELOG_USER_&newBranch..md
host echo "This file is meant for business stakeholders and QA reviewers." >> reports/CHANGELOG_USER_&newBranch..md
 
prompt ✅ Human-readable CHANGELOG created: reports/CHANGELOG_USER_&newBranch..md