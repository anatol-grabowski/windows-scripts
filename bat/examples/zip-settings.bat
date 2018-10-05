@echo off
ren "%TOT_DIR%\backup" backup.zip
set "archname=%TOT_DIR%\backup.zip"
%TOT_DIR%\_4_PORTABLE\_1_BASIC_APPS\7-Zip\7z.ex_app a -tzip %archname% %*
for %%A in (%*) do (
	%TOT_DIR%\_4_PORTABLE\_1_BASIC_APPS\7-Zip\7z.ex_app rn %archname% %%~nxA %%~pnxA
)
ren %archname% backup