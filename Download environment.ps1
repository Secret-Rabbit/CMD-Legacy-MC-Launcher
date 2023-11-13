# This file checks and downloads all the necessary libraries, natives, as well as Oracle JDK 8u321.

$jinput = @{
	FilePath = "bin"; FileName = "jinput-2.0.5.jar"; FileHash = "39c7796b469a600f72380316f6b1f11db6c2c7c4"
	FileUrl = "https://libraries.minecraft.net/net/java/jinput/jinput/2.0.5/jinput-2.0.5.jar"
}
$jutils = @{
	FilePath = "bin"; FileName = "jutils-1.0.0.jar"; FileHash = "e12fe1fda814bd348c1579329c86943d2cd3c6a6"
	FileUrl = "https://libraries.minecraft.net/net/java/jutils/jutils/1.0.0/jutils-1.0.0.jar"
}
$lwjgl = @{
	FilePath = "bin"; FileName = "lwjgl-2.9.4-nightly-20150209.jar"; FileHash = "697517568C68E78AE0B4544145AF031C81082DFE"
	FileUrl = "https://libraries.minecraft.net/org/lwjgl/lwjgl/lwjgl/2.9.4-nightly-20150209/lwjgl-2.9.4-nightly-20150209.jar"
}
$lwjgl_util = @{
	FilePath = "bin"; FileName = "lwjgl_util-2.9.4-nightly-20150209.jar"; FileHash = "d51a7c040a721d13efdfbd34f8b257b2df882ad0"
	FileUrl = "https://libraries.minecraft.net/org/lwjgl/lwjgl/lwjgl_util/2.9.4-nightly-20150209/lwjgl_util-2.9.4-nightly-20150209.jar"
}

$natives_windows = @{
	FilePath = "bin"; FileName = "lwjgl-platform-2.9.4-nightly-20150209-natives-windows.jar"; FileHash = "b84d5102b9dbfabfeb5e43c7e2828d98a7fc80e0"
	FileUrl = "https://libraries.minecraft.net/org/lwjgl/lwjgl/lwjgl-platform/2.9.4-nightly-20150209/lwjgl-platform-2.9.4-nightly-20150209-natives-windows.jar"
}
$lwjgl_natives = @{
	FilePath = "bin/natives"; FileName = "lwjgl.dll" ; FileHash = "6F1661FC6952312A9F34DFA6D3840B46E9C85E63"
}
$lwjgl64_natives = @{
	FilePath = "bin/natives"; FileName = "lwjgl64.dll"; FileHash = "F4013116D6750829851370ED19A9EAF8251AD6E1"
}
$OpenAL32_natives = @{
	FilePath = "bin/natives"; FileName = "OpenAL32.dll"; FileHash = "EDE381BF55E7D0CD3A7E058237BBC66A8FF63837"
}
$OpenAL64_natives = @{
	FilePath = "bin/natives"; FileName = "OpenAL64.dll"; FileHash = "97362FBA53DFB6D9581B8C64829F4B1D98A97855"
}
$manifest_natives = @{
	FilePath = "bin/natives/META-INF"; FileName = "MANIFEST.MF"; FileHash = "310DF5381BCD2F24B192EA65679AA96F22356284"
}

$JDK32 = @{
	FilePath = ""; FileName = "jdk-8u321-windows-i586.zip"; FileHash = "A8C13E343EC70B51E5D42857B5004CF29C280E15"; FileLength = "298285350"
	FileUrl = "https://download.macromedia.com/pub/coldfusion/java/java8/8u321/jdk/jdk-8u321-windows-i586.zip"
}
$JDK64 = @{
	FilePath = ""; FileName = "jdk-8u321-windows-x64.zip"; FileHash = "9FD5C9DF46499EC1BA161759B1AD46A5F1BD6C05"; FileLength = "309923186"
	FileUrl = "https://download.macromedia.com/pub/coldfusion/java/java8/8u321/jdk/jdk-8u321-windows-x64.zip"
}

# $name = @{
# 	FilePath = "bin"; FileName = ""; FileHash = ""
# 	FileUrl = ""
# }

function Get-File {
	param(
		$FilePath,
		$FileName,
		$FileHash,
		$FileUrl
	)
	$filefullpath = "./.minecraft/" + $FilePath + "/" + $FileName
	if (Test-Path $filefullpath) {
		Write-Host "File" $FileName "found!" -ForegroundColor Green
		Write-Host "Hash verification..."
	}
	else {
		Write-Host "File" $FileName "was not found." -ForegroundColor Red
		Write-Host "Downloading file..."
		Invoke-WebRequest $FileUrl -OutFile $filefullpath
	}
	if ((Get-FileHash $filefullpath -Algorithm SHA1).Hash -eq $FileHash) { Write-Host "Hash is valid!" -ForegroundColor Green } else {
		do {
			Write-Host "Hash verification failed." -ForegroundColor Red
			Write-Host "Downloading file..."
			Invoke-WebRequest $FileUrl -OutFile $filefullpath
		}
		while ((Get-FileHash $filefullpath -Algorithm SHA1).Hash -ne $FileHash)
	}
}

function Get-Folder {
	param (
		$CreateFolder
	)
	$CreateFolderfull = "./" + $CreateFolder
	if (Test-Path $CreateFolderfull) {
		Write-Host "$CreateFolder folder found!" -ForegroundColor Green
	}
	else {
		Write-Host "Creating a $CreateFolder folder" -ForegroundColor Yellow
		New-Item -Path $CreateFolderfull -ItemType Directory
	}
}

function Get-Natives {
	param (
		$FilePath,
		$FileName,
		$FileHash,
		$FileUrl
	)
	if (Test-Path .\.minecraft\bin\natives) {
		Remove-Item -Path ".\.minecraft\bin\natives" -Recurse -Force
	}
	Get-File @natives_windows
	$filefullpath = "./.minecraft/" + $natives_windows.FilePath + "/" + $natives_windows.FileName
	Rename-Item  $filefullpath "natives.zip"
	Expand-Archive ".\.minecraft\bin\natives.zip" ".\.minecraft\bin\natives"
	Remove-Item ".\.minecraft\bin\natives.zip" -Recurse -Force
}

function Search-Natives {
	param (
		$FilePath,
		$FileName,
		$FileHash
	)
	$filefullpath = "./.minecraft/" + $FilePath + "/" + $FileName
	if (Test-Path $filefullpath) {
		Write-Host "File" $FileName "found!" -ForegroundColor Green
		Write-Host "Hash verification..."
	}
	else {
		Write-Host "File " $FileName " was not found." -ForegroundColor Red
		Write-Host "Downloading file..."
		Get-Natives
	}
	if ((Get-FileHash $filefullpath -Algorithm SHA1).Hash -eq $FileHash) { Write-Host "Hash is valid!" -ForegroundColor Green } else {
		do {
			Write-Host "Hash verification failed." -ForegroundColor Red
			Write-Host "Downloading file..."
			Get-Natives
		}
		while ((Get-FileHash $filefullpath -Algorithm SHA1).Hash -ne $FileHash)
	}
}

function Get-JDK {
	param (
		$FilePath,
		$FileName,
		$FileHash,
		$FileUrl,
		$FileLength
	)
	if ([System.IntPtr]::Size -eq 4) {
		if ((Get-ChildItem "./.minecraft/jdk" -recurse -Force | Measure-Object Length -s).sum -eq $JDK32.FileLength) {
			Write-Host "The required JDK has already been downloaded!" -ForegroundColor Green
		}
		else {
			Remove-Item -Path ".\.minecraft\jdk" -Recurse -Force
			Write-Host "Downloading JDK archive"
			Get-File @JDK32
			$filefullpath = "./.minecraft/" + $JDK32.FileName
			Write-Host "Unpacking JDK..."
			Expand-Archive $filefullpath ".\.minecraft\jdk"
			Write-Host "Deleting JDK archive"
			Remove-Item -Path $filefullpath -Recurse -Force
		}
	}
	else {
		if ((Get-ChildItem "./.minecraft/jdk" -recurse -Force | Measure-Object Length -s).sum -eq $JDK64.FileLength) {
			Write-Host "The required JDK has already been downloaded!" -ForegroundColor Green
		}
		else {
			if ((Get-ChildItem "./.minecraft/jdk" -recurse -Force | Measure-Object Length -s).sum -eq $JDK32.FileLength) {
				Write-Host "Installed 32-bit Java on a 64-bit system" -ForegroundColor Yellow
			}
			else {
				Remove-Item -Path ".\.minecraft\jdk" -Recurse -Force
				Write-Host "Downloading JDK archive"
				Get-File @JDK64
				$filefullpath = "./.minecraft/" + $JDK64.FileName
				Write-Host "Unpacking JDK..."
				Expand-Archive $filefullpath ".\.minecraft\jdk"
				Write-Host "Deleting JDK archive..."
				Remove-Item $filefullpath -Recurse -Force
			}
		}
	}
}

Get-Folder .minecraft
Get-Folder .minecraft/bin
Get-Folder .minecraft/jdk
""
""
Get-File @jinput
""
Get-File @jutils
""
Get-File @lwjgl
""
Get-File @lwjgl_util
""
""
Search-Natives @lwjgl_natives
""
Search-Natives @lwjgl64_natives
""
Search-Natives @OpenAL32_natives
""
Search-Natives @OpenAL64_natives
""
Search-Natives @manifest_natives
""
""
Get-JDK

