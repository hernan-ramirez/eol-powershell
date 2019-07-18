Write-Host 
$snapin = Get-PSSnapin | Where-Object {$_.Name -eq 'Microsoft.SharePoint.Powershell'}
if ($snapin -eq $null) {
Write-Host "Loading SharePoint Powershell Snapin"
Add-PSSnapin "Microsoft.SharePoint.Powershell"
}
if ($snapin -ne $null) {
Write-Host "SharePoint Powershell Snapin already loaded"
}

Write-Host "Creating new Blank site for lab exercise 1 and 2"
$SiteTitle = "Lab 13 - SharePoint BI Lab"
$SiteUrl = "/sites/Lab13a"
$SiteUrl = $(Get-Item env:\IgniteUrl).value + $SiteUrl
$SiteTemplate = "STS#1"
 
$targetUrl = Get-SPSite | Where-Object {$_.Url -eq $SiteUrl}
if ($targetUrl -ne $null) {
  Write-Output "Deleting exisitng site"
  Remove-SPSite -Identity $SiteUrl -Confirm:$false
}

$NewSite = New-SPSite -URL $SiteUrl -OwnerAlias Administrator -Template $SiteTemplate -Name $SiteTitle
$RootWeb = $NewSite.RootWeb

# display site info
Write-Host 
Write-Host "Site created successfully" -foregroundcolor Green
Write-Host "-------------------------------------" -foregroundcolor Green
Write-Host "URL:" $RootWeb.Url -foregroundcolor Yellow
Write-Host "ID:" $RootWeb.Id.ToString() -foregroundcolor Yellow
Write-Host "Title:" $RootWeb.Title -foregroundcolor Yellow
Write-Host "-------------------------------------" -foregroundcolor Green

Write-Host 
Write-Host "Creating new PerformancePoint site for lab exercise 3"

$SiteTitle = "Lab 13 - PerformancePoint Lab"
$SiteUrl = "/sites/Lab13b"
$SiteUrl = $(Get-Item env:\IgniteUrl).value + $SiteUrl
$SiteTemplate = "PPSMASite#0"
 
$targetUrl = Get-SPSite | Where-Object {$_.Url -eq $SiteUrl}
if ($targetUrl -ne $null) {
  Write-Output "Deleting exisitng site"
  Remove-SPSite -Identity $SiteUrl -Confirm:$false
}

$NewSite = New-SPSite -URL $SiteUrl -OwnerAlias Administrator -Template $SiteTemplate -Name $SiteTitle
$RootWeb = $NewSite.RootWeb

# display site info
Write-Host 
Write-Host "Site created successfully" -foregroundcolor Green
Write-Host "-------------------------------------" -foregroundcolor Green
Write-Host "URL:" $RootWeb.Url -foregroundcolor Yellow
Write-Host "ID:" $RootWeb.Id.ToString() -foregroundcolor Yellow
Write-Host "Title:" $RootWeb.Title -foregroundcolor Yellow
Write-Host "-------------------------------------" -foregroundcolor Green