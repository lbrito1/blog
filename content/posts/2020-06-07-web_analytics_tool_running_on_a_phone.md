---
title: Web analytics tool running on a phone
created_at: 2020-06-07 14:45:40 -0300
kind: article
published: false
---
try this:

wget https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt
bash fix-ruby-bigdecimal.sh.txt

and this after the one above:

$PREFIX/lib/ruby/2.6.0/aarch64-linux-android/bigdecimal/util.so

THANKS TO XEFFYR
NGINX monitoring
$request_time

https://www.nginx.com/products/nginx-amplify/

https://www.netguru.com/codestories/nginx-tutorial-performance
## Benchmarking

log-based took as much as app

Pingdom

90ms wait (server write)

San Francisco
800ms, mostly SSL + connecting

São Paulo
590ms, 658, 700
GTM: 295 script + 105 + 50 = 450ms
181 + 100 + 50
169 110 50

Stress test

```
curl 192.168.0.23:8080/update-blog-stats -POST -d "token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"

siege -c10 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"

no changes added to commit (use "git add" and/or "git commit -a")
➜  android-analytics git:(master) ✗ ga .
➜  android-analytics git:(master) ✗ gc
[master 1ba2d47] Refactors nginx config.
 1 file changed, 81 insertions(+), 118 deletions(-)
 rewrite config/nginx.conf (77%)
➜  android-analytics git:(master) gp
Counting objects: 4, done.
Delta compression using up to 12 threads.
Compressing objects: 100% (4/4), done.
Writing objects: 100% (4/4), 693 bytes | 693.00 KiB/s, done.
Total 4 (delta 2), reused 0 (delta 0)
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com-personal:lbrito1/android-analytics.git
   0625e63..1ba2d47  master -> master
➜  android-analytics git:(master) curl 192.168.0.23:8080/update-blog-stats -POST -d "token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
➜  android-analytics git:(master) siege -c10 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 10 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:           1101 hits
Availability:          93.62 %
Elapsed time:           9.34 secs
Data transferred:         0.04 MB
Response time:            0.08 secs
Transaction rate:       117.88 trans/sec
Throughput:           0.00 MB/sec
Concurrency:            9.93
Successful transactions:        1101
Failed transactions:            75
Longest transaction:          0.25
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c20 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 20 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            422 hits
Availability:          29.14 %
Elapsed time:           3.33 secs
Data transferred:         0.48 MB
Response time:            0.15 secs
Transaction rate:       126.73 trans/sec
Throughput:           0.15 MB/sec
Concurrency:           19.55
Successful transactions:         422
Failed transactions:          1026
Longest transaction:          0.24
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c16 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 16 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            368 hits
Availability:          26.29 %
Elapsed time:           3.24 secs
Data transferred:         0.49 MB
Response time:            0.14 secs
Transaction rate:       113.58 trans/sec
Throughput:           0.15 MB/sec
Concurrency:           15.85
Successful transactions:         368
Failed transactions:          1032
Longest transaction:          0.62
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c16 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 16 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            415 hits
Availability:          28.66 %
Elapsed time:           3.34 secs
Data transferred:         0.49 MB
Response time:            0.13 secs
Transaction rate:       124.25 trans/sec
Throughput:           0.15 MB/sec
Concurrency:           15.93
Successful transactions:         415
Failed transactions:          1033
Longest transaction:          0.27
Shortest transaction:         0.00

➜  android-analytics git:(master) 1 cat /proc/acpi/bbswitch
➜  android-analytics git:(master) siege -c10 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 10 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:           1173 hits
Availability:          62.33 %
Elapsed time:           9.71 secs
Data transferred:         0.33 MB
Response time:            0.08 secs
Transaction rate:       120.80 trans/sec
Throughput:           0.03 MB/sec
Concurrency:            9.95
Successful transactions:        1173
Failed transactions:           709
Longest transaction:          0.22
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c10 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 10 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:           1094 hits
Availability:          75.87 %
Elapsed time:           9.29 secs
Data transferred:         0.16 MB
Response time:            0.08 secs
Transaction rate:       117.76 trans/sec
Throughput:           0.02 MB/sec
Concurrency:            9.94
Successful transactions:        1094
Failed transactions:           348
Longest transaction:          0.24
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c20 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 20 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            396 hits
Availability:          27.75 %
Elapsed time:           3.22 secs
Data transferred:         0.49 MB
Response time:            0.16 secs
Transaction rate:       122.98 trans/sec
Throughput:           0.15 MB/sec
Concurrency:           19.65
Successful transactions:         396
Failed transactions:          1031
Longest transaction:          0.25
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c20 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 20 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            278 hits
Availability:          21.21 %
Elapsed time:           2.21 secs
Data transferred:         0.49 MB
Response time:            0.16 secs
Transaction rate:       125.79 trans/sec
Throughput:           0.22 MB/sec
Concurrency:           19.65
Successful transactions:         278
Failed transactions:          1033
Longest transaction:          0.23
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c16 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
** SIEGE 4.0.4
** Preparing 16 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            404 hits
Availability:          28.19 %
Elapsed time:           3.27 secs
Data transferred:         0.48 MB
Response time:            0.13 secs
Transaction rate:       123.55 trans/sec
Throughput:           0.15 MB/sec
Concurrency:           15.83
Successful transactions:         404
Failed transactions:          1029
Longest transaction:          0.24
Shortest transaction:         0.00

➜  android-analytics git:(master) siege -c16 -t10s --content-type "application/x-www-form-urlencoded" "192.168.0.23:8080/update-blog-stats POST token=M1mI0c53WcDu2FD0EIvQOdNlS9gWQtyh&url=test-url"
➜  android-analytics git:(master) siege -c16 -t10s "192.168.0.23:8080/hello"
** SIEGE 4.0.4
** Preparing 16 concurrent users for battle.
The server is now under siege...
Lifting the server siege...
Transactions:           1496 hits
Availability:         100.00 %
Elapsed time:           9.00 secs
Data transferred:         0.09 MB
Response time:            0.10 secs
Transaction rate:       166.22 trans/sec
Throughput:           0.01 MB/sec
Concurrency:           15.90
Successful transactions:        1496
Failed transactions:             0
Longest transaction:          0.23
Shortest transaction:         0.03

➜  android-analytics git:(master) siege -c32 -t10s "192.168.0.23:8080/hello"
** SIEGE 4.0.4
** Preparing 32 concurrent users for battle.
The server is now under siege...siege aborted due to excessive socket failure; you
can change the failure threshold in $HOME/.siegerc

Transactions:            477 hits
Availability:          31.53 %
Elapsed time:           2.84 secs
Data transferred:         0.52 MB
Response time:            0.19 secs
Transaction rate:       167.96 trans/sec
Throughput:           0.18 MB/sec
Concurrency:           31.38
Successful transactions:         477
Failed transactions:          1036
Longest transaction:          0.30
Shortest transaction:         0.01

```



## Motivation

I run my personal site, as well as this blog, on Github Pages. They're static sites - I write something (such as this blog post -- more on that in the [about page](https://lbrito1.github.io/blog/about.html)), run some compilers and the end result is an HTML page that is then served by Github Pages.

There are pros and cons to this approach. A pretty good pro is that that Github Pages is free and very simple to use. I don't have to set up billing details or worry about how to deploy my page. I compile the markdown files, commit and push, and Github takes care of the rest (there's a [deploy script](https://github.com/lbrito1/sane-blog-builder/blob/development/deploy.sh) I wrote to make that a one-step process).

A negative point is that I don't have a lot of control over the server that Github is kindly hosting and serving these pages. I'm curious about who, if anyone at all, is reading my posts and where they're from. Mind you, that's about it -- I could care less about the click heatmap, which div they interact with most or what their "online profile" is. In fact I would argue that most of those details are or lead to a lot of what is wrong with the Internet these days. I just think it is fun to know someone from Nepal or Iceland read my post about [using a phone as a Ruby server](https://lbrito1.github.io/blog/2020/02/repurposing-android.html).

## Requirements

1. Per-page view count
2. Nice to have: per-country user info


postgres, sequel gem

no password


pg_hba.conf
