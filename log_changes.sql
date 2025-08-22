-- ============================
-- SQLcl Script : log_changes.sql
-- ============================

-- Prompt for old and new branch names
define oldBranch = 'main'
define newBranch = '1.0'

-- Create reports folder if not exists
host mkdir -p reports

-- Log only file names that changed
host "git diff --name-only &oldBranch..&newBranch > reports/files_changed_&oldBranch._to_&newBranch..txt"

-- Log file change summary
host "git diff --stat &oldBranch..&newBranch > reports/summary_&oldBranch._to_&newBranch..txt"

-- Log full diff patch
host "git diff &oldBranch..&newBranch > reports/diff_&oldBranch._to_&newBranch..patch"

prompt
prompt ✅ Change logs generated in ./reports folder
prompt
