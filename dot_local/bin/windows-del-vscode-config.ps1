# 删除指定目录
function Remove-DirectoryIfExists {
    param (
        [string]$directory
    )

    if (Test-Path $directory) {
        Remove-Item -Recurse -Force $directory
        Write-Output "Deleted: $directory"
    } else {
        Write-Output "Directory does not exist: $directory"
    }
}

# 获取环境变量路径
$appData = [System.Environment]::GetFolderPath('ApplicationData')
$localAppData = [System.Environment]::GetFolderPath('LocalApplicationData')
$userProfile = [System.Environment]::GetFolderPath('UserProfile')

# 构建要删除的目录路径
$directoriesToDelete = @(
    "$appData\Code",
    "$localAppData\Code",
    "$userProfile\.vscode"
)

# 删除目录
foreach ($directory in $directoriesToDelete) {
    Remove-DirectoryIfExists -directory $directory
}