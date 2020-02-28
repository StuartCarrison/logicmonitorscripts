$ToUpload = "\\gbdc1-filesr-2\AX Integration\Ax Inbound\Warehouse\TBUK\XPO IDD04 Shipment Confirmation_EC\1_To_Upload\"
$Completed = "\\gbdc1-filesr-2\AX Integration\Ax Inbound\Warehouse\TBUK\XPO IDD04 Shipment Confirmation_EC\4_Completed\"
$ErrorPath = "\\gbdc1-filesr-2\AX Integration\Ax Inbound\Warehouse\TBUK\XPO IDD04 Shipment Confirmation_EC\3_Error\"
$Processing = "\\gbdc1-filesr-2\AX Integration\Ax Inbound\Warehouse\TBUK\XPO IDD04 Shipment Confirmation_EC\2_Processing\"
$paths = ($toUpload),($Completed),($ErrorPath), ($Processing)
$dt = New-Object System.Data.DataTable("Files")
$col1 = New-Object system.Data.DataColumn Name,([string])
$col2 = New-Object system.Data.DataColumn LastWriteTime,([datetime])
$col3 = New-Object system.Data.DataColumn Path,([string])
$dt.columns.add($col1)
$dt.columns.add($col2)
$dt.columns.add($col3)

foreach ($Path in $Paths)
{
$Result = get-childitem -path $path | Sort LastWriteTime | select Name, LastWriteTime -Last 1	
      $nRow = $dt.NewRow()
            $nRow.Name = $Result.Name
            $nRow.LastWriteTime = $Result.LastWriteTime
	    $nRow.Path = $path
            $dt.Rows.Add($nRow)
}

#Find the newest file
$ResultAsText = $dt | sort LastWriteTime | select -last 1
$Newest = $ResultAsText.LastWriteTime | Out-String
$PathofNewest = $ResultAsText.Path + $ResultAsText.Name

#Return a number to allow logic monitor to raise an alert
$CurrentDateTime = get-date
$FIleDateTime = Get-date($Newest)
$Difference = ($currentdateTime - $FileDateTime).TotalMinutes
#Return Something for LogicMonitor
Write-Host "LatestFile=${PathofNewest}";
Write-Host "LastWriteTime=${Newest}";
Write-Host "MinutesSinceLastFile=${Difference}";
return 0;
