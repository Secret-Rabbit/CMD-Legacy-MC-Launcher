@echo off
title Legacy-MC-Launcher
call Settings.bat
@if %DownloadEnvironment%==True @echo on
@if %DownloadEnvironment%==True powershell -File ".\Download environment.ps1"
@if %DownloadEnvironment%==True @echo off
path .\.minecraft\jdk\jdk1.8.0_321\bin
set APPDATA=.\
set StartArgs=-Xmx%RamXmx% -Xms%RamXms% -XX:HeapDumpPath=MojangTricksIntelDriversForPerformance_javaw.exe_minecraft.exe.heapdump -Dhttp.proxyHost=betacraft.uk -Djava.util.Arrays.useLegacyMergeSort=true -Djava.library.path=.minecraft\bin\natives -cp ".minecraft\bin\jinput-2.0.5.jar;.minecraft\bin\jutils-1.0.0.jar;.minecraft\bin\lwjgl-2.9.4-nightly-20150209.jar;.minecraft\bin\lwjgl_util-2.9.4-nightly-20150209.jar;.minecraft\bin\minecraft.jar" net.minecraft.client.Minecraft %MCNick%
@if %Debugmode%==False start javaw %StartArgs%
@if %Debugmode%==True @echo on
@if %Debugmode%==True java %StartArgs% > log.txt
@if %Debugmode%==True pause