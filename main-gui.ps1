#! powershell

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '276,384'
$Form.text                       = "Alpha_V1.00"
$Form.TopMost                    = $True
$Form.StartPosition              = "CenterScreen"
$Form.FormBorderStyle            = 'Fixed3D'
$Form.MaximizeBox                = $false
$Form.MinimizeBox                = $false

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "IP CHECK"
$Button1.width                   = 80
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(10,17)
$Button1.Font                    = 'Microsoft Sans Serif,10'

$Button2                         = New-Object system.Windows.Forms.Button
$Button2.text                    = "DNS Check"
$Button2.width                   = 80
$Button2.height                  = 30
$Button2.location                = New-Object System.Drawing.Point(100,17)
$Button2.Font                    = 'Microsoft Sans Serif,9'

$Button3                         = New-Object system.Windows.Forms.Button
$Button3.text                    = "NetAdapter Status"
$Button3.width                   = 80
$Button3.height                  = 30
$Button3.location                = New-Object System.Drawing.Point(190,17)
$Button3.Font                    = 'Microsoft Sans Serif,7'

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Comp Name"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.Text                     = "Computer Name:" + $env:COMPUTERNAME
$Label1.location                 = New-Object System.Drawing.Point(115,367)
$Label1.Font                     = 'Microsoft Sans Serif,10,style=Bold'

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $true
$TextBox1.width                  = 246
$TextBox1.height                 = 262
$TextBox1.Scrollbars             = "Vertical"
$TextBox1.ReadOnly               = $true
$TextBox1.Text                   = "Waiting for input..."
$TextBox1.location               = New-Object System.Drawing.Point(13,100)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$ComboBox1                       = New-Object system.Windows.Forms.ComboBox
$ComboBox1.text                  = "Application Hunter"
$ComboBox1.width                 = 245
$ComboBox1.height                = 47
@(list_apps) | ForEach-Object {[void] $ComboBox1.Items.Add($_)}
$ComboBox1.location              = New-Object System.Drawing.Point(14,59)
$ComboBox1.Font                  = 'Microsoft Sans Serif,10,style=Bold'
$ComboBox1.DropDownStyle         = 'DropDownList'

$Form.controls.AddRange(($Button1,$TextBox1,$Button2, $Button3, $Label1, $ComboBox1))

$Button1.Add_Click({ IP-Check })
$Button2.Add_Click({ DNS-Check})
$Button3.Add_Click({ NetAdapter-Status})


#Write your logic code here

function IP-Check {
    $check_results=Test-Connection -ComputerName (hostname) -Count 1  | Select IPV4Address | Format-Table -HideTableHeaders | Out-String
    $TextBox1.text=$check_results
}

function DNS-Check {
    $check_dns=Resolve-DnsName -Name www.google.com | Select Name, Type, IPAddress | Format-Table -HideTableHeaders | Out-String
    $TextBox1.text=$check_dns
}

function NetAdapter-Status {
    $check_netadapter=Get-NetAdapter | SELECT name, status | where status -eq ‘up’ | Format-Table -HideTableHeaders | Out-String
    $TextBox1.text=$check_netadapter
}

function App_Hunter {
    #add input via ComboBox1 for process name
    $query_app=get-process -name | select-object -ExpandProperty responding
}

function list_apps {
    get-process | select processname -unique
}

[void]$Form.ShowDialog()
