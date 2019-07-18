$web = Get-SPWeb http://erreiusgestion.errepar.com/sitios/Erreius
$list = $web.Lists["Documentos Erreius"]
$listDest = "Legislacion"


$spQuery = New-Object Microsoft.SharePoint.SPQuery
$spQuery.ViewAttributes = "Scope='Recursive'"
$spQuery.RowLimit = 10
$spQuery.ViewFields = "<FieldRef Name='ContentType' /><FieldRef Name='iusFechaDictado' /><FieldRef Name='iusFechaSancion' /><FieldRef Name='iusMes' /><FieldRef Name='iusAnio' /><FieldRef Name='iusArea' />"
#$spQuery.ViewFieldsOnly = $true #IMPORTANTE!! para reducir el costo del "select"
$caml = '<OrderBy Override="TRUE"><FieldRef Name="ID"/></OrderBy><Where><Eq><FieldRef Name="ContentType"/><Value Type="Text">Legislación</Value></Eq></Where>'
$spQuery.Query = $caml 


do
{
	$estampa = [System.DateTime]::Now.ToString("yyyy.MM.dd hh:mm:ss")
	Write-Host $estampa -foregroundcolor red -backgroundcolor yellow
	
	$listItems = $list.GetItems($spQuery)
	$spQuery.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
	
	foreach($item in $listItems)
	{
		if($item.Level -eq "Published"){ #Si los documentos estan publicados -- descarta los borrador(Draft) y los desprotegidos(Checkout)
			
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$valCampo = $item["iusFechaSancion"]
				
				if($valCampo){
					
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("yyyy"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("MM"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("dd"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}

					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd"))
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor Magenta
				
			$item.File.MoveTo($URLdestino.ServerRelativeUrl + "/" + $item.Name)
			
		}else{
			#Write-Output $item.Url | Out-File -FilePath "C:\DesprotegidosLegis.txt" -Append
			Write-Host "!!! " $item.Level " | " $item.Url " -> " $URLdestino -foregroundcolor Yellow -backgroundcolor Red
		}
	}
}
while ($spQuery.ListItemCollectionPosition -ne $null)



################################
##
##  Version corta solo para ver el nombre de los archivos
##
################################

do
{
	$estampa = [System.DateTime]::Now.ToString("yyyy.MM.dd hh:mm:ss")
	Write-Host $estampa -foregroundcolor red -backgroundcolor yellow
	
	$listItems = $list.GetItems($spQuery)
	$spQuery.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
	
	foreach($item in $listItems)
	{
		$item.Name
	}
}
while ($spQuery.ListItemCollectionPosition -ne $null)




################################
##
##  Esto era para correrlo todo junto
##
################################

do
{
	$estampa = [System.DateTime]::Now.ToString("yyyy.MM.dd hh:mm:ss")
	Write-Host $estampa -foregroundcolor red -backgroundcolor yellow
	
	$listItems = $list.GetItems($spQuery)
	$spQuery.ListItemCollectionPosition = $listItems.ListItemCollectionPosition
	
	foreach($item in $listItems)
	{
		if($item.Level -eq "Published"){ #Si los documentos estan publicados -- descarta los borrador(Draft) y los desprotegidos(Checkout)
		
			if($item["ContentType"] -eq "Jurisprudencia"){ ## CORRIENDO
				
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$valCampo = $item["iusFechaDictado"]
				
				if($valCampo){
					
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("yyyy"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("MM"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("dd"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}

					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd"))
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor red				
			}
			elseif($item["ContentType"] -eq "Legislación"){ ####### SUSPENDIDO
			
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$valCampo = $item["iusFechaSancion"]
				
				if($valCampo){
					
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("yyyy"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("MM"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("dd"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}

					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd"))
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor Magenta
			}
			elseif($item["ContentType"] -eq "Doctrina"){ ## LISTO
			
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$mes = $item["iusMes"] -replace "/", " - "
				$valCampo = $item["iusAnio"] + "/" + $mes
				
				
				if($item["iusAnio"]){
					
					if(!$web.GetFolder($listDest + "/" + $item["iusAnio"]).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$item["iusAnio"])
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $item["iusAnio"]),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$mes)
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}

					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo)
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor green				
			}
			elseif($item["ContentType"] -eq "Dictamen"){ ## LISTO
			
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$valCampo = $item["iusFechaDictado"]
				
				if($valCampo){
					
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("yyyy"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("MM"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					if(!$web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd")).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem($web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM")),[Microsoft.SharePoint.SPFileSystemObjectType]::Folder,$valCampo.ToString("dd"))
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}

					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo.ToString("yyyy/MM/dd"))
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor Magenta -foregroundcolor Cyan		
			}
			elseif($item["ContentType"] -eq "Documento Erreius"){ ## LISTO
			
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$valCampo = $item["iusArea"][0].Label
				
				if($valCampo){
					if(!$web.GetFolder($listDest + "/" + $valCampo).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $valCampo)
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo)
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor Yellow				
			}
			elseif($item["ContentType"] -eq "Modelo"){ ## LISTO
			
				$URLdestino = $web.GetFolder($listDest + "/Otros")
				$valCampo = $item["iusArea"][0].Label
				
				if($valCampo){
					if(!$web.GetFolder($listDest + "/" + $valCampo).Exists){ 
						$spFolder = $web.Lists[$listDest].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $valCampo)
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					$URLdestino = $web.GetFolder($listDest + "/" + $valCampo)
				}
				
				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor Magenta				
			}
			elseif($item["ContentType"] -eq "Consulta Frecuente"){ ## LISTO
			
				$URLdestino = $web.GetFolder("Consultas/Otros")
				
				if($item["iusArea"][0].Label -ne ""){
					if(!$web.GetFolder("Consultas/" + $item["iusArea"][0].Label).Exists){ 
						$spFolder = $web.Lists["Consultas"].AddItem("",[Microsoft.SharePoint.SPFileSystemObjectType]::Folder, $item["iusArea"][0].Label)
						$spFolder.SystemUpdate()
						Write-Host $spFolder.Folder.Url "Creada"
					}
					$URLdestino = $web.GetFolder("Consultas/" + $item["iusArea"][0].Label)
				}

				Write-Host $item["ContentType"] " | " $item.Url " -> " $URLdestino -foregroundcolor DarkYellow
			}
			
			#$item.File.MoveTo($URLdestino.ServerRelativeUrl + "/" + $item.Name)
		}
	}
}
while ($spQuery.ListItemCollectionPosition -ne $null)

