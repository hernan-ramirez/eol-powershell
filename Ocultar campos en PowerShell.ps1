###
#
# Ocultar Campos "_0" en PS 
# By HJR
#
###

$eol = New-Object Microsoft.SharePoint.SPSite("http://eolGestion.errepar.com/sitios/eolGestion") 

$web = $eol.OpenWeb()
$web.Lists | format-table Title

###
# Setear el nombre de la biblio!
###
$lista = $web.Lists["Jurisprudencia Judicial"] # <- Nombre Biblio !IMPORTANTE
$campos = $lista.Fields | select Title, Hidden | where-object {$_.title -like  "*_0"}
$campos

$campos.GetEnumerator() | Foreach-Object {
	$campo = $lista.Fields[$_.title]
	$campo.Title
	$campo.Hidden = $true
	$campo.Update()
	$campo.Hidden
}



