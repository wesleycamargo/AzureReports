[CmdletBinding()]
param (
    [string] $outputPath = ".\report"
)

az login

$resources = az resource list -o json | ConvertFrom-Json

$resourcesExport = New-Object System.Collections.ArrayList($null)

foreach ($resource in $resources) {
    
    $newResource = [PSCustomObject]@{        
        id            = $resource.id
        location      = $resource.location
        resourceGroup = $resource.resourceGroup
        name          = $resource.name
    }

    $resourcesExport.Add($newResource) | Out-Null

}

$date = (Get-Date).ToString("yyyy-MM-dd-HH-mm")
$fileName = "Resources-$date.csv"

$fullFilePath = Join-Path -Path $outputPath -ChildPath $fileName

New-Item -ItemType Directory -Force -Path $outputPath 

$resourcesExport | Export-Csv -NoTypeInformation -Append -Path $fullFilePath -Force -Delimiter ";" 
