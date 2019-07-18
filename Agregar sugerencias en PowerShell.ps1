$centraladminurl = 'http://vm-sakti:2000/sitios/eol/'
 # fill in the name of the search service application
 $searchservicename = "Aplicación de servicio de búsqueda"
 # fill in the name of the termstore
 $termstorename = "Servicio de metadatos para EOL"
 # fill in the name of the group
 $groupname = "Errepar On Line"
 # fill in the name of the termset
 $termsetname = "Índice de Contenidos"
 
# Connect with the taxonomy
 $taxonomySite = get-SPSite $centraladminurl
 $taxonomySession = Get-SPTaxonomySession -site $taxonomySite
 $termStore = $taxonomySession.TermStores[$termstorename]
 write-host "Connection made with term store -"$termStore.Name
 
# connect with the search service application
 $ss = Get-SPEnterpriseSearchServiceapplication -Identity $searchservicename
 
# function to add a query suggestion
 function addqs($term)
 {
   New-SPEnterpriseSearchLanguageResourcePhrase -SearchApplication $ss -Language ES-AR -Type QuerySuggestionAlwaysSuggest -Name $term.Name -ErrorAction SilentlyContinue
   Write-Host $term.Name
   foreach($nonrootterm in $term.get_Terms())
     {
         addqs($nonrootterm)
     }
 }
 
$termStoreGroup = $termStore.Groups[$groupname]
 $termSet = $termStoreGroup.TermSets[$termsetname]
 
foreach ($term in $termSet.get_Terms())
 {
     addqs($term)
 }
 
# Starting the timer job to prepare the query suggestions
 $job = Get-SPTimerJob "Prepare query suggestions"
 $job | Start-SPTimerJob
 Write-Host "Timer job started"
 
$taxonomySite.Dispose()
 Write-Host "Connection disposed"
