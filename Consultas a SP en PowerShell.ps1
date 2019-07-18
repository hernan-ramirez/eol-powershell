###########
#
# INCLUYO LOS OBJETOS DE SP 
#
###########

$snapin = Get-PSSnapin | Where-Object {$_.Name -eq 'Microsoft.SharePoint.Powershell'}
if ($snapin -eq $null) {
    Write-Host "Loading SharePoint Powershell Snapin"
    Add-PSSnapin Microsoft.SharePoint.Powershell
    Set-location $home
}
if ($snapin -ne $null) {
Write-Host "SharePoint Powershell Snapin already loaded"
}

###########
#
# EN KURMA 
#
###########

$eol = New-Object Microsoft.SharePoint.SPSite("http://eolGestion.errepar.com/sitios/eolGestion") 
$errepar = $eol.OpenWeb()

$ius = New-Object Microsoft.SharePoint.SPSite("http://erreiusGestion.errepar.com/sitios/erreius") 
$erreius = $ius.OpenWeb()

$errepar.Lists | select Title


###########
#
# BORRAR BIBLIO MASIVA 
# -- pegarle al sitio con URL del servidor, nada de balanceo.
# -- Ejemplo http://srv-kurma:2100/sitios/eolGestion
#
###########

$web = Get-SPWeb("http://srv-kurma:2100/sitios/eolGestion")
$web.Lists | format-table title

$list = $web.Lists["Documentos"]

$list.AllowDeletion = $true
$list.Update()

$list.ParentWeb.AllowUnsafeUpdates = $true
$list.Delete()


###########
#
#  ENTIDADES EN SHAREPOINT 
#
###########

$sitio = New-Object Microsoft.SharePoint.SPSite("http://v2sis09/sitios/Grupo") 

$web = $sitio.OpenWeb()

$lista = $web.Lists["Documentos compartidos"]

$campo = $lista.Fields["Título"]

$lista.FieldIndexes.Add($campo)

$campo.AllowMultipleValues = "True"

$campo.Indexed = "True"

$campo.EnforceUniqueValues = "True"

$campo.Update()


###########
#
#  METADATOS ADMINISTRADOS 
#
###########

$sitio = New-Object Microsoft.SharePoint.SPSite("http://eolGestion.errepar.com/sitios/eolGestion")

$session = New-Object Microsoft.SharePoint.Taxonomy.TaxonomySession($sitio);

$termStore = $session.TermStores["Servicio de metadatos para EOL Nuevo"];

$termStore.Groups | select name

$grupo = $termStore.Groups["Errepar On Line"]

$grupo.TermSets | select name

$setIndice = $grupo.TermSets["Índice de Contenidos"]

$termino = $setIndice.GetTerms("Ley del Impuesto al Valor Agregado", "true")

$termino | select name, Terms


###########
#
#  INTERMEDIOS 
#
###########

Get-Help Get-SPSite
SPSite
$web
$lista | Get-Member
$lista.Fields | select Title
$campo.Update
clear

Get-Command -noun *SPLog*
Get-SPLogEvent | Where-Object {$_.Category -like "*Suscriptor*"} | Out-GridView
Get-SPLogEvent –StartTime (Get-Date).AddMinutes(-2) | Out-GridView


###########
#
# SEGURIDAD DE ELEMENTOS 
#
###########

$sitio = New-Object Microsoft.SharePoint.SPSite("http://v2sis09:8008/sitios/Colaboracion/") 

$web = $sitio.OpenWeb()

$lista = $web.Lists["Documentos"]

$primerItem = $lista.items[1]

$primerItem.RoleAssignments

$primerItem.BreakRoleInheritance("true")

$roles = $primerItem.RoleAssignments

$account = $web.SiteGroups["Erreius"]
$siterole = $web.RoleDefinitions["Leer"]
$assignment = New-Object Microsoft.SharePoint.SPRoleAssignment($account)
$assignment.RoleDefinitionBindings.Add($siterole);

$roles.AddToCurrentScopeOnly($assignment)

$primerItem.SystemUpdate()

$primerItem.RoleAssignments

$roles.RemoveFromCurrentScopeOnly($assignment)

$primerItem.ResetRoleInheritance()


###########
#
#  INSTALAR Y ADMINISTRAR SOLUCIONES 
#
###########

Get-Command -noun *SPsolu*

Get-SPSolution

Update-SPSolution -GACDeployment


###########
#
#  SERVICIO DE BUSQUEDAS 
#
###########

Get-SPEnterpriseSearchServiceApplication | Get-SPEnterpriseSearchRankingModel | fl Name, ID


###########
#
#  Propiedades de sitios 
#
###########

$site = Get-SPSite  http://sharepoint.errepar.com/sitios/Sistemas  
$web = $site.AllWebs["Desarrollo"]     
$web.ID 

$site = Get-SPSite http://sharepoint.errepar.com/sitios/Sistemas
## $site = New-Object Microsoft.SharePoint.SPSite("http://sharepoint.errepar.com/sitios/Sistemas")
$web = $site.OpenWeb("Desarrollo")
write-host "Site: " + $site.id
write-host "Web: " + $web.id
$web.lists | Format-Table title,id -AutoSize
$web.Dispose()
$site.Dispose()