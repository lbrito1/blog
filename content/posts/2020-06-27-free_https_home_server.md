---
title: Setting up a free HTTPS home server
created_at: 2020-06-27 19:48:21 -0300
kind: article
published: true
---

<%= render('/post_hero.*', src: '/blog/assets/images/2020/cool-background.png', alt: "", caption: "") %>

Try searching for "free dynamic dns https", "free domain with SSL" or anything similar. There won't be a lot of meaningful results. Sure, some of the results are pretty close, like [this guide](https://www.freecodecamp.org/news/free-https-c051ca570324/) on how to get free SSL certification from Cloudflare, or [this one](https://medium.com/@jeremygale/how-to-set-up-a-free-dynamic-hostname-with-ssl-cert-using-google-domains-58929fdfbb7a) on setting up a free dynamic hostname with SSL, but they all assume you _already own a domain_. If you're looking for a completely free domain that you can use for your personal web server that also has verified SSL, there are very few results.

But why was I even looking for this?

I'm working on a side project. It has a web server that communicates with a static web page hosted on Github Pages. There are a lot of ways of setting that up; in my particular case, I have a local (as in in my house) HTTP web server accepting traffic on a non-standard port (port `80` is blocked by my ISP [for commercial reasons](https://www.reddit.com/r/InternetBrasil/comments/e9v5o0/abertura_das_portas_80_e_443_na_claronet/) -- this detail is of paramount importance, but more on that later). It is accessible through my external IP (which is dynamic), which can be mapped to a dynamic DNS domain.

I wanted to run a simple API on the web server and access it through static pages (like this blog) hosted on Github Pages (which has a verified SSL certificate). [I asked the Internet](https://stackoverflow.com/questions/62378047/is-it-possible-to-make-a-cross-domain-javascript-request-to-http-from-https) if it is possible to call from a SSL-verified page (in JavaScript) a different server that does not have a verified SSL certificate (that is, my aforementioned webapp running in my home server). It isn't, so the conclusion was that I needed somehow to get a verified SSL certificate for my dynamic DNS domain.

Having no idea whether this was possible, I started to research.

<!-- more -->

## Setting up Dynamic DNS

Most ISPs provide dynamic IP addresses for their residential customers, while static IP addresses are usually reserved to the "commercial" or "business" tier. That means your public IP address changes (usually every [14 days](https://vicimediainc.com/often-ip-addresses-change/)), so DNS servers will have to keep track of your changing IP somehow. That kind of service is called Dynamic DNS, or DDNS for short.

[Several companies](https://free-for.dev/#/?id=dns) provide DDNS service for free. Some of them also provide a free subdomain, which is useful if you don't own a domain yourself (I don't). I've tried out most of the free DDNS providers, the most prominent seeming to be Hurricane Electric, No-ip, Dynu and DuckDNS. If you're up for it there are even several blog posts out there explaining [how to set up your own dynamic DNS server](https://blog.heckel.io/2016/12/31/your-own-dynamic-dns-server-powerdns-mysql/).

I wasn't feeling too adventurous so I decided to set up shop with DuckDNS. It is really easy to set up, comes with a great HTTP API for updating the domain's TXT, provides free subdomains that don't expire (No-ip for instance has subdomains that expire after 30 days), and has a valid SSL certificate. They have a page [explaining how to set up the actual DDNS service](https://www.duckdns.org/install.jsp), so I'll skip that.

### Caveat: carrier-grade NAT

One big potential problem in the DDNS setup is whether you're behind a [carrier-grade NAT (CGNAT)](https://www.wikiwand.com/en/Carrier-grade_NAT), which some ISPs unfortunately do. In short, being in a CGNAT boils down to not having a public IP address -- you're part of your ISP's private network, and your router's "public" IP address is actually a private IP address within that private network, which the ISP translates to and from the Internet.

CGNATs suck, and it essentially [makes using DDNS impossible](https://www.reddit.com/r/HomeNetworking/comments/6ahcp6/rtn66u_isp_changed_to_cgnat_broke_ddns/). You can find out if you're behind a CGNAT by comparing your WAN IP address (displayed in the router admin page) and your public IP. If they differ, you're probably behind a CGNAT

## Setting up a verified SSL

I had set up the dynamic DNS service, and the next step was finding out if it was even possible to obtain a free valid SSL certificate for my subdomain.

[Let's Encrypt](https://letsencrypt.org/getting-started/) provides free valid SSL certificates, which are usually obtained by using [Certbot](https://certbot.eff.org/), a handy software that will handle most of the complicated SSL verification process you. There are [several other](https://letsencrypt.org/docs/client-options/) alternative tools that implement the same protocol used by Let's Encrypt, but I really recommend using Certbot -- it has much better out-of-the-box functionality than all the other tools I tried out, and the community is much bigger. The only caveat I could find is that you need `sudo` access to use it properly.

One thing I'd wish someone had told me before I spent hours looking for alternatives to Certbot is that **it doesn't have to be executed in the host that is ultimately going to obtain the SSL certificate**. This might be a crucial bit of information if you can't run as root on the actual host that will obtain the SSL certificate, which was my case. It is perfectly fine to run Certbot on a separate computer, obtain the SSL certificates and then `scp` them to the correct host.

Now, as I mentioned, my ISP blocks incoming traffic to port `80` for their residential customers. This is relevant because Let's Encrypt uses by default the **HTTP-01 challenge** in the SSL verification process, and it requires the ports `80` and `443` to be open. However, LE also offers the alternative **[DNS-01 challenge](https://letsencrypt.org/docs/challenge-types/)** which **does not** require those ports to be open (but requires the ability to update TXT domain records, which not all DDNS service providers allow -- No-ip, for instance, does not). I happened to find out about this by reading [this very helpful post](https://www.splitbrain.org/blog/2017-08/10-homeassistant_duckdns_letsencrypt) from someone in a similar predicament (home server, port `80` not available) saying he used this alternative challenge successfully with DuckDNS (thank you!). In [this Server Fault answer](https://serverfault.com/a/812038/578968), the poster explains how to use Certbot with the DNS-01 challenge (thank you!).

### Running Certbot with DNS-01 and DuckDNS

DNS-01 works by confirming that you can modify the DNS TXT record of your domain.

Here's the command to start SSL verification with Certbot using DNS-01 and a DuckDNS subdomain, and the expected output:

<div class="highlight"><pre><code class="language-bash">
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
</code></pre></div>

At this point you have to do as the program says: update the DNS TXT record. Thankfully, this is exceedingly easy to do with DuckDNS (see their [spec page](https://www.duckdns.org/spec.jsp) for instructions).

You can verify that the TXT was updated by running `dig`:

<div class="highlight"><pre><code class="language-bash">
$ dig my-subdomain.duckdns.org TXT

; <<>> DiG 9.11.3-1ubuntu1.12-Ubuntu <<>> my-subdomain.duckdns.org TXT
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 21765
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;my-subdomain.duckdns.org. IN  TXT

;; ANSWER SECTION:
my-subdomain.duckdns.org. 59 IN  TXT "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

;; Query time: 335 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Jun 15 18:50:41 -03 2020
;; MSG SIZE  rcvd: 114
</code></pre></div>

Once you confirmed the TXT value, the remainder of Certbot's output should be this success message:

<div class="highlight"><pre><code class="language-bash">
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/my-subdomain.duckdns.org/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/my-subdomain.duckdns.org/privkey.pem
   Your cert will expire on 2020-09-13. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot
   again. To non-interactively renew *all* of your certificates, run
   "certbot renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le
</code></pre></div>

All set! You now have a valid SSL certificate. You'll still need to place it in the right place, which will vary depending on what web server you're using. For example, if you're using Nginx, the configuration file might look something like this:

<div class="highlight"><pre><code>
server {
  ssl_certificate /path/to/fullchain.pem;
  ssl_certificate_key /path/to/privkey.pem;
  ...
}
</code></pre></div>

## Conclusion

There's quite a lot of shady-looking websites out there offering for a monthly fee the exact same thing as I just wrote about. When researching this, not knowing too much about most of these topics, I was almost fooled into accepting that this just couldn't be done for free for some unknown technical reason. There _had_ to be a reason why there were no Google results for this -- maybe my case was too specific, or maybe other people are less cheap than I am and just pay for a domain and get the SSL stuff for free.

I still have no good explanation as to why the kind of guide I just wrote above didn't show up in my research. Maybe people don't care about home servers, or maybe I'm just not too good at searching (probably both). In any case, hopefully this post will make it clear that setting up a DDNS subdomain with SSL for free is not only possible, but really not that complicated.
