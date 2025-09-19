@echo off
REM 自动构建并上传到腾讯云服务器的 /var/www/html/StringArtWeb 子目录

REM 构建项目
call npm run build
if errorlevel 1 (
    echo 构建失败，终止部署！
    pause
    exit /b
)

REM 上传 dist 文件夹内容到服务器指定子目录
set SERVER_USER=root
set SERVER_IP=49.235.190.13
set SERVER_PORT=2222
set SERVER_PATH=/var/www/html/StringArtWeb

scp -P %SERVER_PORT% -r dist\* %SERVER_USER%@%SERVER_IP%:%SERVER_PATH%

echo Deploy Done！
pause