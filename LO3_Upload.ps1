param (
    [Parameter(Mandatory)][string]$gridid = $( Read-Host "Please input Pando market ID to upload data to"),
    [Parameter(Mandatory)][string]$email=$( Read-Host "Please input Pando account email"),
    [Parameter(Mandatory)][string]$password=$( Read-Host "Please input Pando account password"),
    [Parameter(Mandatory)][string]$directory=$( Read-Host "Please input path to directory containing files to upload" ),
    [Parameter(Mandatory)][string]$region=$( Read-Host "Please input Pando region (US, EU, or AU)"),
    [string]$filter=$( Read-Host "Please input string to filter files by (otherwise all files in directory will be included)")
)

# Get the login token
$iduri = "https://identity.$region.lo3energy.net/login"
$idbody = @{
    email = "$email"
    password = "$password"
} | ConvertTo-Json -Compress

$idresp = Invoke-RestMethod -Method Post  -ContentType 'application/json' -Uri $iduri -Body $idbody 

# Upload the file
$afguri = "https://afg.$region.lo3energy.net/data/$gridid/upload"

$token = $idresp.id_token

$headers = @{
    Authorization = "Bearer $token"
}
Get-childitem $directory -Filter "$filter" | foreach-object {
  $fileBytes = [System.IO.File]::ReadAllBytes($_.FullName);
  $fileEnc = [System.Text.Encoding]::GetEncoding('UTF-8').GetString($fileBytes);
  $boundary = [System.Guid]::NewGuid().ToString(); 
  $LF = "`r`n";
  $fname = Split-Path -Path $_ -Leaf

  $uploadbody = ( 
    "--$boundary",
    "Content-Disposition: form-data; name=upload; filename=`"$fname`"",
    "Content-Type: text/plain; charset-utf-8$LF",
    $fileEnc,
    "--$boundary--$LF" 
  ) -join $LF


$afgresp = Invoke-RestMethod -ContentType "multipart/form-data; boundary=`"$boundary`"" -Headers $headers -Method Post -Uri $afguri -Body $uploadbody

Write-Host $afgresp
}