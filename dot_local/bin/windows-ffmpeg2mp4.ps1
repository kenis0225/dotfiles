$sourceFolder = 'E:\shared\iphone'
$destinationFolder = 'E:\shared\iphone'

Get-ChildItem -Path $sourceFolder -Filter *.mov | ForEach-Object {
    $destinationFile = Join-Path -Path $destinationFolder -ChildPath ($_.BaseName + '.mp4')
    ffmpeg -i $_.FullName -vcodec copy -acodec copy $destinationFile
}