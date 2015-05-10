# Miniwiki.js

Miniwiki is an experimental, minimal wiki software, that
only allows reading and writing from and to articles atm.

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

# Performance

Probably the most interesting aspect of this is the way
pages are stored: We could try to save on io access and
cache pages in memory, though this poses a bit of a problem
when running multiple workers, as we need a way to
invalidate caches on write requests.
I'd rather not deal with this problem, so I decided to read
the file from disk on every request. The FS cache should be
capable of dealing with cache invalidation issues.

In order to simulate a bit of cpu usage we also compute the
34th number from the Fibonacci sequence;

## Tests

I wrote a simple program to test the performance of this
approach: `$ node_modules/.bin/coffee bin/miniwiki_perftest`

Using this script I managed to send and receive about 2.5k
GET requests per second. Both the client as well as the
server workers ran on the same machine.

Removing the Fibonacci computation did not change the
http thrughoutput. Neither did serving the GET requests
without the FS cache.
I think it is possible, that in this case the limiting factor
might actually be my laptop's memory bandwidth.
