project init -name APEX_APP -schemas WKSP_EBS2CLOUD_MIGRATION


!git init


--If exists then removes it

host rmdir /s /q "src\apex\applications\f201"

apex export -applicationid 201 -split -dir src/apex/applications

--apex export -applicationid 201 -split -dir "src/apex/applications" -skipExportDate


!git add .
!git commit -m "initializing repository with default project SAMPLE_N files"

ACCEPT REMOTE_URL CHAR PROMPT 'Enter Git remote URL: '
!git remote add origin &REMOTE_URL

!git checkout -b base-release


!git push -u origin main
!git push -u origin base-release




