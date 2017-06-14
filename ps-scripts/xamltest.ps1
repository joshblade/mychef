[void][System.Reflection.Assembly]::LoadWithPartialName('presentationframework')
[xml]$XAML = @'
<Window
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
        xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
        xmlns:local="clr-namespace:OSDetails"
        mc:Ignorable="d"
        Title="MainWindow" Height="350" Width="525">
    <Grid x:Name="Details" Margin="0,-1,0,1">
        <Label x:Name="OSDetails" Content="OS Details" Height="36.448" Margin="206.47,10,206.469,0" VerticalAlignment="Top" FontFamily="Calibri" FontSize="22" FontWeight="Bold" HorizontalAlignment="Center" Width="105.661"/>
        <Label x:Name="hostName" Content="HostName" HorizontalAlignment="Left" Margin="100.969,45.755,0,0" VerticalAlignment="Top">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <Label x:Name="OSName" Content="Operating System Name" HorizontalAlignment="Left" Margin="27.665,72.406,0,0" VerticalAlignment="Top">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <Label x:Name="AvailableMemory" Content="Available Memory" HorizontalAlignment="Left" Margin="61.939,97.821,0,0" VerticalAlignment="Top">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <Label x:Name="OSArch" Content="OS Archetecture" HorizontalAlignment="Left" Margin="70.952,123.54,0,0" VerticalAlignment="Top">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <Label x:Name="WinDir" Content="Windows Directory" HorizontalAlignment="Left" Margin="56.929,149.015,0,145.404" d:LayoutOverrides="Height">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <Label x:Name="WinVer" Content="Windows Version" HorizontalAlignment="Left" Margin="65.595,0,0,117.909" VerticalAlignment="Bottom">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <Label x:Name="label" Content="System Drive" HorizontalAlignment="Left" Margin="88.619,0,0,90.44" VerticalAlignment="Bottom">
            <Label.Effect>
                <DropShadowEffect/>
            </Label.Effect>
        </Label>
        <TextBox x:Name="txthostName" Height="23" Margin="168.2,49.6,95.2,0" TextWrapping="Wrap" Text="HostName" VerticalAlignment="Top">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <TextBox x:Name="txtOSName" Height="23" Margin="168.2,75.6,95.2,0" TextWrapping="Wrap" Text="OS Name" VerticalAlignment="Top">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <TextBox x:Name="txtavailMem" Height="23" Margin="167.375,101.6,95.2,0" TextWrapping="Wrap" Text="Available Memory" VerticalAlignment="Top">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <TextBox x:Name="txtOSArch" Margin="168.2,127.8,95.2,0" TextWrapping="Wrap" Text="OS Architecture" Height="23" VerticalAlignment="Top">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <TextBox x:Name="txtwinDir" Margin="172.376,152.8,95.2,144.6" TextWrapping="Wrap" Text="WinDir">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <TextBox x:Name="txtwinVer" Height="23" Margin="172.376,0,95.2,118.4" TextWrapping="Wrap" Text="WinVer" VerticalAlignment="Bottom">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <TextBox x:Name="txtSysDrive" Height="23" Margin="172.376,0,95.2,90.4" TextWrapping="Wrap" Text="System Drive" VerticalAlignment="Bottom">
            <TextBox.Effect>
                <DropShadowEffect/>
            </TextBox.Effect>
        </TextBox>
        <Button x:Name="btnEXIT" Content="EXIT" Margin="172.376,0,95.2,44.04" VerticalAlignment="Bottom"/>

    </Grid>
</Window>
'@
#Read XAML
$reader=(New-Object System.Xml.XmlNodeReader $xaml)
try{$Form=[Windows.Markup.XamlReader]::Load( $reader )}
catch{Write-Host "Unable to load Windows.Markup.XamlReader. Some possible causes for this problem include: .NET Framework is missing PowerShell must be launched with PowerShell -sta, invalid XAML code was encountered."; exit}

#===========================================================================
# Store Form Objects In PowerShell
#===========================================================================
$xaml.SelectNodes("//*[@Name]") | %{Set-Variable -Name ($_.Name) -Value $Form.FindName($_.Name)}

#===========================================================================
# Add events to Form Objects
#===========================================================================
$btnExit.Add_Click({$form.Close()})

#===========================================================================
# Stores WMI values in WMI Object from Win32_Operating System Class
#===========================================================================
$oWMIOS = Get-WmiObject win32_OperatingSystem

#===========================================================================
# Links WMI Object Values to XAML Form Fields
#===========================================================================
$txtHostName.Text = $oWMIOS.PSComputerName

#Formats and displays OS name
$aOSName = $oWMIOS.name.Split("|")
$txtOSName.Text = $aOSName[0]

#Formats and displays available memory
$sAvailableMemory = [math]::round($oWMIOS.freephysicalmemory/1000,0)
$sAvailableMemory = "$sAvailableMemory MB"
$txtAvailMem.Text = $sAvailableMemory

#Displays OS Architecture
$txtOSArch.Text = $oWMIOS.OSArchitecture

#Displays Windows Directory
$txtWinDir.Text = $oWMIOS.WindowsDirectory

#Displays Version
$txtWinVer.Text = $oWMIOS.Version

#Displays System Drive
$txtSysDrive.Text = $oWMIOS.SystemDrive

#===========================================================================
# Shows the form
#===========================================================================
$Form.ShowDialog() | out-null