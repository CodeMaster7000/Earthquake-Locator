$Format="csv" 
$MinMagnitude=6.0
$OrderBy="magnitude" 

function ListEarthquakes { 
	Write-Progress "Loading data..."
	$Quakes = (Invoke-WebRequest -URI "https://earthquake.usgs.gov/fdsnws/event/1/query?format=$Format&minmagnitude=$MinMagnitude&orderby=$OrderBy" -userAgent "curl" -useBasicParsing).Content | ConvertFrom-CSV
	foreach ($Quake in $Quakes) {
		[int]$Depth = $Quake.depth
		New-Object PSObject -Property @{ Mag=$Quake.mag; Depth="$Depth km"; Location=$Quake.place; Time=$Quake.time }
	}
	Write-Progress -completed "Loading complete."
}
try {
	ListEarthquakes | Format-Table -property @{e='Mag';width=5},@{e='Location';width=42},@{e='Depth';width=12},Time 
	exit 0 
} catch {
	"An unexpected error occurred in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])."
	exit 1
}
