if not exist my.ini (
  echo [mysqld]>> my.ini
  echo datadir=".\data">> my.ini
)

mysqld --defaults-file=".\my.ini" --console %*
