@echo off
echo Java processes before:
jps

set "pids=jps^| grep "GradleDaemon"^| awk "{print $1}""
FOR /F "tokens=* USEBACKQ" %%F IN (`%pids%`) DO (
	echo Killing process with pid "%%F"
	Taskkill /PID %%F /F
)

echo Java processes after:
jps

