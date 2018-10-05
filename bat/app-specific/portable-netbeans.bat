@echo off
set pathDrive=%cd:~0,2%
set pathConf=%pathDrive%\_PORTABLE\netbeans\etc\netbeans.conf
set pathJDK=%pathDrive%\_PORTABLE\Java\jdk\jdk1.8.0_66\
set pathUser=%pathDrive%\_PORTABLE\netbeans\UserDir\
set pathNetbeans=%pathDrive%\_PORTABLE\netbeans\bin\netbeans.exe

echo # ${HOME} will be replaced by JVM user.home system property > %pathConf%
echo netbeans_default_userdir="%pathUser%">> %pathConf%
echo.>> %pathConf%
echo # Options used by NetBeans launcher by default, can be overridden by explicit>> %pathConf%
echo # command line switches:>> %pathConf%
echo netbeans_default_options="-J-client -J-Xverify:none -J-Xss2m -J-Xms32m -J-XX:PermSize=32m -J-XX:MaxPermSize=200m -J-Dapple.laf.useScreenMenuBar=true -J-Dsun.java2d.noddraw=true">> %pathConf%
echo # Note that a default -Xmx is selected for you automatically.>> %pathConf%
echo # You can find this value in var/log/messages.log file in your userdir.>> %pathConf%
echo # The automatically selected value can be overridden by specifying -J-Xmx here>> %pathConf%
echo # or on the command line.>> %pathConf%
echo.>> %pathConf%
echo # If you specify the heap size (-Xmx) explicitely, you may also want to enable>> %pathConf%
echo # Concurrent Mark ^& Sweep garbage collector. In such case add the following>> %pathConf%
echo # options to the netbeans_default_options:>> %pathConf%
echo # -J-XX:+UseConcMarkSweepGC -J-XX:+CMSClassUnloadingEnabled -J-XX:+CMSPermGenSweepingEnabled>> %pathConf%
echo # (see http://wiki.netbeans.org/wiki/view/FaqGCPauses)>> %pathConf%
echo.>> %pathConf%
echo # Default location of JDK, can be overridden by using --jdkhome ^<dir^> >> %pathConf%
echo netbeans_jdkhome="%pathJDK%">> %pathConf%
echo.>> %pathConf%
echo # Additional module clusters, using ${path.separator} (';' on Windows or ':' on Unix):>> %pathConf%
echo #netbeans_extraclusters="/absolute/path/to/cluster1:/absolute/path/to/cluster2">> %pathConf%
echo.>> %pathConf%
echo # If you have some problems with detect of proxy settings, you may want to enable>> %pathConf%
echo # detect the proxy settings provided by JDK5 or higher.>> %pathConf%
echo # In such case add -J-Djava.net.useSystemProxies=true to the netbeans_default_options.>> %pathConf%

start %pathNetbeans% --console suppress
