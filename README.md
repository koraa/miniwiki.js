# Miniwiki.js

Miniwiki is an experimental, minimal wiki software, that
only allows reading and writing from and to articles atm.

In order to simulate a bit of cpu usage we also compute the
34th number from the Fibonacci sequence;

Articles are directly stored on disk, without any caching
besides the FS cache.

# Usage

```
  ./bin/miniwiki [STORAGE_DIR] [PORT] [NUMWORKERS]

  Defaults:
    STORAGE_DIR = /tmp/miniwiki
    PORT = 8080
    NUMCPUS = number of cpus
```

## API Requests

```
  # Create a page: POST to /$page
  $ curl 127.0.0.1:8080/$page-name -d "Hello World"

  # Read a page
  $ curl 127.0.0.1:8080/$page-name
  Hello World
```
