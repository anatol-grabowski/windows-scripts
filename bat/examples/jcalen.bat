@set @junk=1 /*
@echo off
cscript //nologo //E:jscript %0 %*
goto :eof
*/

x = WScript.Arguments
Yr = x(0) ; Mo = x(1)

YS = "JanFebMarAprMayJunJulAugSepOctNovDec"
MN = Mo<1 || Mo>12 ? Mo : YS.substr(3*Mo-3, 3) // Month Name
WScript.echo(" ", Yr, "         ", MN)
WScript.echo(" Mo Tu We Th Fr Sa Su")
WD = new Date(Yr, Mo-1, 1).getDay() ;
if (WD==0) WD = 7 // Week Day Number of 1st
LD = new Date(Yr, Mo, 0).getDate() // Last Day of month
Wk = "" ; for (D=1 ; D < WD ; D++) Wk += "   "

for (D=1 ; D<=LD ; D++) {
  Wk = Wk + " " + (D<10 ? "0"+D : D) ; WD++
  if ((WD==8) || (D==LD)) { WScript.echo(Wk) ; WD = WD-7 ; Wk = "" }
  }

WScript.echo("        ------       ")
