# Bashupload

A containerized selfhost version of https://bashupload.com/

## Quick Start

### Unraid
The template can be downloaded here
<pre>
  https://github.com/Mainfrezzer/UnRaid-Templates/blob/main/bashupload.xml
</pre>

### Docker run
<pre>
docker run --name bashupload\
    --restart unless-stopped\
    -v /my/own/appdir:/app\
    -v /my/own/appfiledir:/app/files `#optional`\
    -e UID=99 \
    -e GID=100 \
    -p 80:80/tcp \
    -d mainfrezzer/bashupload
</pre>