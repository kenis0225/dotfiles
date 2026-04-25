# Define functions for checking installation and configuring SSH
function Install-OpenSSH {
    Write-Output "Checking if OpenSSH Client is installed..."
    $clientInstalled = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Client*' | Select-Object -ExpandProperty State

    if ($clientInstalled -eq "NotPresent") {
        Write-Output "Installing OpenSSH Client..."
        Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
    } else {
        Write-Output "OpenSSH Client is already installed."
    }

    Write-Output "Checking if OpenSSH Server is installed..."
    $serverInstalled = Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*' | Select-Object -ExpandProperty State

    if ($serverInstalled -eq "NotPresent") {
        Write-Output "Installing OpenSSH Server..."
        Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
    } else {
        Write-Output "OpenSSH Server is already installed."
    }
}

function Start-OpenSSHService {
    Write-Output "Starting sshd service..."
    Start-Service sshd
    Write-Output "Setting sshd service to start automatically..."
    Set-Service -Name sshd -StartupType 'Automatic'
}

function Configure-FirewallRule {
    Write-Output "Checking Firewall rule for OpenSSH Server..."
    if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
        Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
        New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    } else {
        Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
    }
}

function Configure-SSH {
    Write-Output "Configuring sshd_config for Administrator login..."
    $sshdConfigPath = "C:\ProgramData\ssh\sshd_config"
    $configContent = Get-Content $sshdConfigPath

    # Add or update necessary settings
    if ($configContent -notcontains "PermitRootLogin yes") {
        Add-Content -Path $sshdConfigPath -Value "`nPermitRootLogin yes"
    }

    if ($configContent -notcontains "PubkeyAuthentication yes") {
        Add-Content -Path $sshdConfigPath -Value "`nPubkeyAuthentication yes"
    }

    if ($configContent -notcontains "PasswordAuthentication yes") {
        Add-Content -Path $sshdConfigPath -Value "`nPasswordAuthentication yes"
    }

    if ($configContent -notcontains "AuthorizedKeysFile .ssh/authorized_keys") {
        Add-Content -Path $sshdConfigPath -Value "`nAuthorizedKeysFile .ssh/authorized_keys"
    }

    # Comment out the lines for administrators
    $configContent = Get-Content $sshdConfigPath
    $newContent = $configContent -replace '^(#?\s*Match Group administrators)', '# Match Group administrators' -replace '^(#?\s*AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys)', '#        AuthorizedKeysFile __PROGRAMDATA__/ssh/administrators_authorized_keys'
    Set-Content -Path $sshdConfigPath -Value $newContent

    Write-Output "Restarting sshd service..."
    Restart-Service sshd
}

# Check if running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Run functions
Install-OpenSSH
Start-OpenSSHService
Configure-FirewallRule
Configure-SSH

Write-Output "OpenSSH has been installed and configured successfully."
