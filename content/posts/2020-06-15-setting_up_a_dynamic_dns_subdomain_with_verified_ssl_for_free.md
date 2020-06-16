---
title: Setting up a dynamic DNS domain with verified SSL for free
created_at: 2020-06-15 19:48:21 -0300
kind: article
published: false
---

Ever wondered if there was a somewhat easy way of getting a dynamic DNS (sub)domain with verified SSL certificates _for free_?

I hadn't either, until a couple of weeks ago. As I was working on a side project that demanded a trusted HTTPS connection to my local web server, I wondered what was the easiest path. This set me in an interesting, and sometimes frustrating, path.

My setup: I have a HTTP web server accepting traffic on a non-standard port (`8080`). Port `80` is blocked by my ISP [for commercial resons](https://www.reddit.com/r/InternetBrasil/comments/e9v5o0/abertura_das_portas_80_e_443_na_claronet/) -- this detail is of paramount importance, but more on that later. It is accessible through my external IP (which is dynamic) or a dynamic DNS domain ([several companies](https://free-for.dev/#/?id=dns) provide this as a free service).

My requirements: I wanted to run a simple API on the web server and access it through static sites (like this blog) hosted on Github Pages (which has a verified SSL certificate -- this is also important).

[I asked the Internet](https://stackoverflow.com/questions/62378047/is-it-possible-to-make-a-cross-domain-javascript-request-to-http-from-https) if it is possible to call a non-SSL-verified server in JavaScript served by an SSL-verified page (it isn't). Thus, the conclusion was that I needed somehow to get a verified SSL certificate for my dynamic DNS domain. Having no idea whether this was possible, I started to research.

<!-- more -->

### Setting up DDNS

### Setting up a verified SSL

DuckDNS offers an API to update TXT records.

curl https://www.duckdns.org/update?domains=android-analytics&token=0da03d19-b6c5-452b-83cb-ef259ca09c2e&txt=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&verbose=true

Verifying:

```
$ dig android-analytics.duckdns.org TXT

; <<>> DiG 9.11.3-1ubuntu1.12-Ubuntu <<>> my-subdomain.duckdns.org TXT
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21765
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;android-analytics.duckdns.org. IN  TXT

;; ANSWER SECTION:
android-analytics.duckdns.org. 59 IN  TXT "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

;; Query time: 335 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Jun 15 18:50:41 -03 2020
;; MSG SIZE  rcvd: 114
```


Certbot


```
$ sudo certbot -d  my-subdomain.duckdns.org --manual --preferred-challenges dns certonly

Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for my-subdomain.duckdns.org

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o: Y

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.my-subdomain.duckdns.org with the following value:

xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/my-subdomain.duckdns.org/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/android-analytics.duckdns.org/privkey.pem
   Your cert will expire on 2020-09-13. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
```

### Nginx

https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/

### Automating

`certbot renew?`

➜  ~ curl https://www.duckdns.org/update\?domains\=android-analytics\&token\=0da03d19-b6c5-452b-83cb-ef259ca09c2e\&txt\=N3uw1PsIpdrC76jb0tLBrhlWjIoDR3-KsknJ0OD9AiA\&verbose\=true
OK
N3uw1PsIpdrC76jb0tLBrhlWjIoDR3-KsknJ0OD9AiA
UPDATED%                                                                        ➜  ~ dig android-analytics.duckdns.org TXT



➜  ~ https://www.duckdns.org/update\?domains\=android-analytics\&token\=0da03d19-b6c5-452b-83cb-ef259ca09c2e\&txt\=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\&verbose\=true
zsh: no such file or directory: https://www.duckdns.org/update?domains=android-analytics&token=0da03d19-b6c5-452b-83cb-ef259ca09c2e&txt=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&verbose=true
➜  ~ curl https://www.duckdns.org/update\?domains\=android-analytics\&token\=0da03d19-b6c5-452b-83cb-ef259ca09c2e\&txt\=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\&verbose\=true
OK
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
UPDATED%                                                                        ➜  ~ dig android-analytics.duckdns.org TXT

; <<>> DiG 9.11.3-1ubuntu1.12-Ubuntu <<>> android-analytics.duckdns.org TXT
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 23899
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;android-analytics.duckdns.org. IN  TXT

;; ANSWER SECTION:
android-analytics.duckdns.org. 59 IN  TXT "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

;; Query time: 349 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Jun 15 18:51:41 -03 2020
;; MSG SIZE  rcvd: 114

### Other

https://help.edovia.com/hc/en-us/articles/115012824927-Carrier-Grade-NAT-Large-Scale-NAT
