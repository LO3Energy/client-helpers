# client-helpers
A place to store scripts, tools and other utilities to help clients access Pando.

## AFG Upload - Powershell
This script gives clients a way to automatically upload to Authenticated File Gateway. Generally, it takes a directory then uploads all the files in it to AFG using supplied credentials. It is run using a few configuration flags:
- `gridid`: ID of the Pando marketplace uploaded data will be associated with
- `region`: Region where the Pando marketplace is hosted (AU, EU, or US)
- `email`: Email of Pando account used for upload (setup by LO3 ahead of time)
- `password`: Password of Pando account used for upload (setup by LO3 ahead of time)
- `directory`: Full path of directory containing files to upload
- `filter`: RegEx string to filter files to upload by, uploads all files in directory by default

An example command is shown below. This would upload files with "January" in their names from the given directory to AFG, associating them with the given grid. This will require a user to enter their password manually after running the script: 

`.\LO3_Upload.ps1 -gridid "99af6bb5a4bd4a2bbcba41e74cea1026" -email "jontest@gmail.com" -directory "C:\data\files\here" -region "au" -filter "*January*"`

Another example shows how the process can be run w/o manual intervention. This would upload every file in the given directory. However, entering the password in the command line is not as secure as entering it manually each time:

`.\LO3_Upload.ps1 -gridid "99af6bb5a4bd4a2bbcba41e74cea1026" -email "jontest@gmail.com" -directory "C:\data\files\here" -region "au" -password "BADPASS"`

After each successful upload, you should see a confirmation message like this: 
`@{hash=c1cd80a36f7f1bb6a9440b1d64b46a5d; bucket=lo3energy-authenticated-file-gateway-prod-au; key=99af6bb5a4bd4a2bbcba41e74cea1026/yonden3.txt.txt}`
