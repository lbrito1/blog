---
title: I replaced Google Analytics with a web server running on my phone
created_at: 2020-07-01 14:45:40 -0300
kind: article
published: true
tags:
- Web development
---

<%= render('/post_hero.*', src: '/blog/assets/images/2020/diagram.png', alt: "", caption: "") %>

Say you run a blog, personal website, small-time business page or something of the sorts. Say you also want to keep an eye on how many visitors you're getting.

The first thing that most people think at this point is "Google Analytics". It mostly works and is free. Its also hosted by Google, which makes it very easy to start using. There aren't many competitors that bring those points to the table, so Google Analytics usually wins by WO at this point.

I used to use Google Analytics to track this blog for those same reasons. But after finding out about [Termux](https://termux.com) and writing [this post](https://lbrito1.github.io/blog/2020/02/repurposing-android.html) about installing a web server on an Android phone, I started toying with the idea that I had this ARM-based, 2GB RAM, Linux-like device with Internet connectivity which must be more than enough for a simple webcounter-like application. After a few weeks of tinkering, here it is!

<!-- more -->

## Motivation

### Why even keep anything?

Before going into this whole thing, there's a very reasonable question to be answered: why do I even need to collect this data?

The answer is simple: I really don't, I just enjoy seeing it. Call it a [vanity metric](https://techcrunch.com/2011/07/30/vanity-metrics/), but I think its just _plain cool_ to know that someone half across the planet read something I wrote months ago (maybe it was just a crawler; I'll take it either way).

It should be no surprise, then, that Google Analytics always felt immensely overkill.

Its heartwarming to know that some nerd from Bhutan read one of my posts in the wee hours of the morning, but that is pretty much all I'm interested in. I could care less about Acquisition Treemaps, Audience Cohort Analysis or Behavior Flow. I'm not making those up: they're all real products available on Google Analytics. I have no idea of what any of those mean, and I'm 100% sure I don't need them.

<%= render('/image-nostretch.*', src: '/blog/assets/images/2020/visitor_count.jpeg', alt: "Visitor counter from the 90s.", caption: "Visitor counter from the 90s.") %>

What I wanted was closer to the late 90s' visitor count GIF above (minus the embarrassment of publicity) than the "I'm the SEO manager at a intersitial online advertising network conglomerate" feeling of Google Analytics' unsightly dashboard:

<%= render('/image.*', src: '/blog/assets/images/2020/ga.png', alt: "Google Analytics dashboard.", caption: "Google Analytics dashboard.") %>

In short, I wanted to geek out, not do advertisement arbitrage.

### And then there is the data

As aforementioned, Google Analytics is great, free, _and hosted by Google_.

They keep your data. I have no idea of what they do with that data, or even what exactly it is that their tracker is sending to their servers (judging from the number of articles showing how to keep the payload below the cap of 8kb, it must be a lot).

<%= render('/image-nostretch.*',
src: '/blog/assets/images/2020/ga_payload.png',
alt: "Google search results for 'google analytics payload size is too large'. 642,000 results.",
caption: "That's a lot of results.") %>

They apparently need that to feed their Lovecraftian "Audience Cohort Analysis"-kind of products.

Fair enough, but I'm pretty sure that for my purposes, a several-kb payload is effectively using a sledgehammer to kill a fly.

By using Google Analytics I was willfully sending Google who-knows-what kind of data designed to build up people's advertising profile. The page views of my blog probably didn't help Google too much in that aspect, sure, but the principle of the whole thing still bothered me enough to do something about it.

### The (lack of) competition

There are a lot of software similar to Google Analytics out there. The most prominent is probably [Matomo](https://matomo.org/), often [posted on Hacker News](https://hn.algolia.com/?dateRange=all&page=0&prefix=true&query=matomo&sort=byPopularity&type=story). It is free, open source and self-hosted (with cloud offerings for a monthly fee).

I would happily use Matomo, but it brings a conundrum:

- Self-hosting implies I had to have some kind of publicly accessible Linux host, which would likely not be entirely free;
- Cloud-hosting comes with a subscription fee.

Those points are trivial if you're running a lucrative business that _needs_ analytics, but paying for this service sounds ludicrous when all you want is simple visitor stats for a personal blog.

## Developing android-analytics

These were the requirements I had for my tracker:
1. Has to run on an old Android phone I have lying around;
2. Has to work with Github Pages-hosted sites;
3. Has a per-page view count;
4. Nice to have: geo info.

These requirements are deceivingly simple, as I quickly learned.

Termux makes it really easy to run many kinds of software on your Android phone, and [I had already tinkered](https://lbrito1.github.io/blog/2020/02/repurposing-android.html) with web servers with Termux. For something as simple as a page view, this should be pretty straightforward.

I had also already registered a dynamic DNS subdomain pointing to my phone, so it was ready to accept incoming traffic from the Internet.

The first major roadblock I faced was getting my Android-hosted web server to communicate with Github Pages. After a couple of days of research, I finally learned that it is basically impossible to make a request from an HTTPS website (which Github Pages is) to an HTTP address (my Dynamic DNS's subdomain). To summarize, you can make that work, but at the cost of having the client browser do something (like actively mark a "allow mixed content" checkbox somewhere in the browser's flags/advanced options).

This lead me to the excruciating path of obtaining and using a verified SSL certificate in my Android phone with a Dynamic DNS subdomain. This took me long enough to want to write a separate [blog post](https://lbrito1.github.io/blog/2020/06/free_https_home_server.html) about it. The TLDR here is that it is entirely possible to get a verified SSL cert for a Dynamic DNS subdomain -- all of it entirely for free. Depending on your ISP, you'll have different choices of SSL challenges, but if you're able to receive TCP requests on port `443`, it is possible to get the certificate for free.

Once I figured out the SSL thing, the rest was pretty much a breeze.

### Basis

I tried out a few different ideas when developing this, but the overall architecture is always the same:

- JavaScript code in my tracked page calls the Android host;
- Android host saves that information in a database;
- Some graphical tool is used to parse that data into something viewable (charts etc).

### First iteration: Sinatra webapp

I started with a [Sinatra](http://sinatrarb.com/) webapp with a single `POST` endpoint that would receive a request from the tracked page and immediately save it in a Postgres database. I used Nginx as a reverse-proxy that handled traffic before passing it to Sinatra.

This approach had the merit of being simple to understand and reliable. Also, it worked.

But after watching it work for a few days, I realized that the whole webapp part was superfluous. Nginx logs all accesses by default, and the logs contain all the information I need: what page was requested, at what time and from what IP. This lead naturally to the second iteration.

### Second iteration: Nginx log parser

Nginx provides flexible, per-endpoint logs: logs are activated for the endpoint that I want (`/damn_fine_coffee`) and deactivated for everything else. This is important because the Internet is full of crawlers that annoyingly hit the root path `/`, which obviously shouldn't count as a page view. As I learned, the web is also surprisingly full of smartypants trying to make their way into `/tp-link`, `/admin` and so on; I also wanted to just ignore those.

The logs provided all the _data_ I needed, but I still needed to transform that _data_ into useful _information_. I found out about [GoAccess](https://goaccess.io/) on Hacker News, and, perhaps surprisingly, it worked out of the box with Termux:

<%= render('/image.*', src: '/blog/assets/images/2020/goaccess.png', alt: "GoAccess dashboard with my Android-hosted data.", caption: "GoAccess dashboard with my Android-hosted data.") %>

At this point I could settle for GoAccess, but it didn't seem to provide any geo info, which I always thought would be a cool feature, so I kept working on my own tool.

I configured Nginx to print CSV-like logs, and [wrote a parser](https://github.com/lbrito1/android-analytics/blob/master/app/compiler.rb) that transforms those log entries into DB entries with geographic information provided by the excellent [geocoder](https://github.com/alexreisner/geocoder) gem, and also annonymizes the request IPs using MD5 hashing. The final step was adding a cron entry to run the parser regularly.

At this point I was getting regular traffic converted to rows in a Postgresql table. I still needed a more convenient way to look at the data, though.

### Third iteration: Adding a viewer

I initially thought about using [Grafana](https://grafana.com/) as a visualization tool. Its free, easy to use, flexible and I was already familiar with it. Unfortunately Grafana doesn't have binaries available for Termux (there's an [issue](https://github.com/termux/termux-packages/issues/4801) open in Termux's repo requesting that), and I wasn't feeling like trying to compile it manually.

Thankfully I found the [blazer](https://github.com/ankane/blazer) gem, which has a very similar concept compared with Grafana: you write SQL queries and it transforms them into charts. That was exactly what I was looking for. The downside is that it requires a full-fledged Rails application to run, but I was okay with that trade-off.

Here's how the data looks like right now:

<%= render('/image.*', src: '/blog/assets/images/2020/android-analytics-screenshot.png', alt: "blazer gem dashboard.", caption: "blazer gem dashboard.") %>

### Final architecture

When someone accesses one of my tracked pages, this is roughly what happens:


1. JavaScript on that page calls my domain (provided for free by [DuckDNS](https://www.duckdns.org/));
2. DuckDNS translates that address to my router's most recent IP;
3. My router receives that request and uses the NAT table to redirect it to my Android phone;
4. On Android, Nginx receives the request and either logs it if the request comes from the right place (my list of tracked pages), or does nothing otherwise;
5. A scheduled Cron job rotates Nginx logs and converts the "old" log into rows in a Postgresql table;
6. I open `<my-android-local-ip>:3000` on my desktop's browser and see charts, maps etc.

The diagram at the beginning of the post shows those same steps, more or less:

<%= render('/image.*', src: '/blog/assets/images/2020/diagram.png', alt: "android-analytics diagram.", caption: "android-analytics diagram.") %>

For a while now I'm using [android-analytics](https://github.com/lbrito1/android-analytics), a tool I built that runs

I run my personal site, as well as this blog, on Github Pages. They're static sites - I write something (such as this blog post -- more on that in the [about page](https://lbrito1.github.io/blog/about.html)), run some compilers and the end result is an HTML page that is then served by Github Pages.

There are pros and cons to this approach. A pretty good pro is that that Github Pages is free and very simple to use. I don't have to set up billing details or worry about how to deploy my page. I compile the markdown files, commit and push, and Github takes care of the rest (there's a [deploy script](https://github.com/lbrito1/sane-blog-builder/blob/development/deploy.sh) I wrote to make that a one-step process).

A negative point is that I don't have a lot of control over the server that Github is kindly hosting and serving these pages. I'm curious about who, if anyone at all, is reading my posts and where they're from. Mind you, that's about it -- I could care less about the click heatmap, which div they interact with most or what their "online profile" is. In fact I would argue that most of those details are or lead to a lot of what is wrong with the Internet these days. I just think it is fun to know someone from Nepal or Iceland read my post about [using a phone as a Ruby server](https://lbrito1.github.io/blog/2020/02/repurposing-android.html).

## Conclusion

Saying this is a "Google Analytics replacement" is like saying a bicycle is a replacement for a truck -- sometimes your really do need a truck, but a lot of times you just need to get from point A to point B, and a bike is really enough.

This is the bike. There's absolutely no need to use a mammoth like Google Analytics for a silly blog, personal site or pet project. In fact one could say there's no need to use _any_ tracking system at all -- which I would say is true, but on the other hand it is kinda cool to see that a guy from Nepal accessed your blog post in the wee hours of the day.

