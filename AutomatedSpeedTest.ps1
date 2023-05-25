#wait 15 min before running this script on start up
#if running this script manually, comment out the line below
timeout /t 900 /nobreak >nul

# Define the path to the speedtest.exe executable
$SpeedtestExePath = "path/to/speedtest.exe"

# Function to detect network connection type
function Get-NetworkConnectionType {
    $wmiQuery = "SELECT * FROM Win32_NetworkAdapter WHERE NetEnabled = 'true'"
    $networkAdapters = Get-WmiObject -Query $wmiQuery

    foreach ($adapter in $networkAdapters) {
        if ($adapter.ProductName -like '<input your pc ethernet adapter name>*') {
            return 'Ethernet'
        }
        elseif ($adapter.ProductName -like '<input your pc wifi adapter name>*') {
            return 'Wi-Fi'
        }
    }
    return 'Unknown'
}

# Determine the network connection type
$ConnectionType = Get-NetworkConnectionType

# If the connection type is unknown, exit the script
if ($ConnectionType -eq 'Unknown') {
    Write-Host "Unable to determine network connection type. Exiting..."
    exit
}

#For users running the script directly, display messages to the console. 
Write-Host "Network Connection Type: $ConnectionType"
Write-Host "Running Speedtest..."

# Run the speedtest and capture the output
$SpeedtestOutput = & $SpeedtestExePath -f json --output-header

# Convert the speedtest output from JSON to PowerShell objects
$SpeedtestData = $SpeedtestOutput | ConvertFrom-Json

# Extract the information we want
$speedTestTime = $SpeedtestData.timestamp

$speedTestPingLow = $SpeedtestData.ping.low
$speedTestPingHigh = $SpeedtestData.ping.high
$speedTestPingAverage = ($speedTestPingLow + $speedTestPingHigh) / 2

$downloadSpeed = $SpeedtestData.download.bytes / 1000000
$uploadSpeed = $SpeedtestData.upload.bytes / 1000000

$interIP = $SpeedtestData.interface.internalIp
$externalIP = $SpeedtestData.interface.externalIp

# Define the path and filename for the CSV file
$CsvFilePath = "<input path to csv file>"

# Create a custom object to store the speed test results and connection type
$testResult = [PSCustomObject]@{
    DateTime = $speedTestTime
    ConnectionType = $ConnectionType
    DownloadSpeed = $downloadSpeed
    UploadSpeed = $uploadSpeed
    Ping = $speedTestPingAverage
    InternalIP = $interIP
    ExternalIP = $externalIP
}

# Append the speedtest results to the CSV file
$testResult | Export-Csv -Path $CsvFilePath -Append -NoTypeInformation