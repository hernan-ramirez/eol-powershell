##
# Programa importador de Propiedades Administradas en PowerShell
# para el servicio de búsqueda de SharePoint.
# Se puede "seleccionar toto" el texto y "copiar y pegar" directamente en una pantalla PS.
#
# Abrir este archivo con Notepad++ con Lenguaje -> P -> PowerShell para su edición.
# by HJR (hernan.ramirez@errepar.com para consultas)
##

#
# Predefino la ubicación de las propiedades a mapear
#

### Instancio el servicio de búsqueda (SSA)
$searchapp = Get-SPEnterpriseSearchServiceApplication "Servicio de búsqueda"
 
### Instancio la categoria del SSA
$category = Get-SPEnterpriseSearchMetadataCategory -SearchApplication $searchapp –Identity Office


# Preparado de la matriz en hashtable de doble dimensión
# Par duo (key = value;) donde value es un array unidimensional.

$propiedades = @{
	#
	# propiedadAdministrada = propiedadRastreada, otraPropiedadRastreada, ..n;
	#
	#"Voces" = "eolVoces", "iusVoces", "ows_eolVoces", "ows_iusVoces";	
	#"Tema" = "eolVoces", "iusVoces", "ows_eolVoces", "ows_iusVoces";
	#"Obra" = "eolObra", "copObra", "ows_eolObra", "ows_copObra"
	"HJR" = "eolVoces", "iusVoces", "ows_eolVoces", "ows_iusVoces";
	"HJRplus" = "eolVoces", "iusVoces", "ows_eolVoces", "ows_iusVoces";
	"HJR" = "eolVoces", "iusVoces", "ows_eolVoces", "ows_iusVoces";
}


# Imprimo en pantalla la matriz hashtable 
# solo para verificar la estructura.
$propiedades


# Repaso en el primer bucle el hashtable
$propiedades.GetEnumerator() | Foreach-Object {    

	$propiedadAdministrada = $_.Key
	$propiedadesRastreadas = $_.Value
	
	# Describo la acción en pantalla
	Write-Host -f Yellow -b Red "Mapear '" + $propiedadAdministrada + "' con estas rastreadas '" + $propiedadesRastreadas + "'" | Out-String

	### Entonces creo propiedad [ADMINISTRADA]
	# Si existe
	if (Get-SPEnterpriseSearchMetadataManagedProperty -SearchApplication $searchapp -Identity $propiedadAdministrada -ea "silentlycontinue"){ 
		
		# Tomo la propiedad.
		$managedproperty = Get-SPEnterpriseSearchMetadataManagedProperty -SearchApplication $searchapp -Identity $propiedadAdministrada 
		Write-Host -f Magenta "La propiedad ADMINISTRADA '" + $propiedadAdministrada + "' ya existe: " + $managedproperty | Out-String
		
	} else { 

		# Sino, la creo.
		$managedproperty = New-SPEnterpriseSearchMetadataManagedProperty -SearchApplication $searchapp -Identity $propiedadAdministrada -Type 1
		$managedproperty.EnabledForScoping = $true
		$managedproperty.Update()		
		Write-Host -f Magenta "Se creo la nueva propiedad ADMINISTRADA '" + $propiedadAdministrada + "'" | Out-String
		
	}
	
	
	# Imprimo en pantalla la propiedad ADMINISTRADA
	$managedproperty
	
	
	# Repaso el segundo bucle (Array simple) para adjuntar las rastreadas a la administrada	
	foreach ($propiedadRastreada in $propiedades[$propiedadAdministrada]){

		# Describo la acción en pantalla
		Write-Host -f Cyan "Agregar la propiedad RASTREADA '" + $propiedadRastreada + "' a la administrada '" + $propiedadAdministrada + "'"

		### Tomo o creo la propiedad [RASTREADA]
		# Si existe
		if (Get-SPEnterpriseSearchMetadataCrawledProperty -SearchApplication $searchapp -Name $propiedadRastreada -ea "silentlycontinue"){ 
			
			# Tomo la propiedad.
			$crawledproperty = Get-SPEnterpriseSearchMetadataCrawledProperty -SearchApplication $searchapp -Name $propiedadRastreada
			Write-Host -f DarkCyan "La propiedad RASTREADA '" + $propiedadRastreada + "' ya existe: " + $crawledproperty | Out-String
				
		} else { 

			# Sino, la creo.
			$crawledproperty = New-SPEnterpriseSearchMetadataCrawledProperty -SearchApplication $searchapp -Name $propiedadRastreada -IsNameEnum $false -VariantType 31 
			Write-Host -f DarkCyan "Se creo la nueva propiedad RASTREADA '" + $propiedadRastreada + "'" | Out-String
				
		}
		
		
		# Imprimo en pantalla la propiedad RASTREADA
		$crawledproperty


		### Realizo el mapeo
		New-SPEnterpriseSearchMetadataMapping -SearchApplication $searchapp -ManagedProperty $managedproperty -CrawledProperty $crawledproperty

	}
	
	# Separador visual "como punto y aparte"
	Out-String
}


