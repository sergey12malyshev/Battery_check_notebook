# скрипт запускающий тревогу при разряде АКБ

"run process battery control!"
while ($True)

{
	# get battery charge and status power:
	$charge = Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty EstimatedChargeRemaining
	$value = Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty  BatteryStatus
	
	Start-Sleep -s 9

	while (($charge -lt 15) -and ($value -eq 1))
	{
		"Current Charge: $charge %."
		[console]::beep(500,300)
		Start-Sleep -s 1
		[console]::beep(460,220)
		Start-Sleep -s 1
		
		# снизим яркость
		(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,0)
		
		$value = Get-CimInstance -ClassName Win32_Battery | Select-Object -ExpandProperty  BatteryStatus
		"battery state: $value"
		
		# подключили адаптер - сбрасываем тревогу
		if ($value -eq 2)
		{
			"DC adapter connect"
			(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,75)
			break
		}				
	}
}

