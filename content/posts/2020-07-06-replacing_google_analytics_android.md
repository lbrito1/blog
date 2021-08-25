---
title: I replaced Google Analytics with a web server running on my phone
created_at: 2020-07-06 10:45:40 -0300
kind: article
published: true
tags:
- Web development
- android
- termux
---

<%= render('/post_hero.*', src: '/blog/assets/images/2020/simple_diagram.png', alt: "", caption: "") %>

>**TLDR** I built [android-analytics](https://github.com/lbrito1/android-analytics), a web analytics tracker running on my phone.

Say you run a blog, personal website, small-time business page or something of the sorts. Say you also want to keep an eye on how many visitors you're getting.

The first thing that most people think at this point is "Google Analytics". It mostly works and is free. Its also hosted by Google, which makes it very easy to start using. There aren't many competitors that bring those points to the table, so Google Analytics usually wins by WO at this point.

I used to use Google Analytics to track this blog for those same reasons. But after finding out about [Termux](https://termux.com) and writing [this post](https://lbrito1.github.io/blog/2020/02/repurposing-android.html) about installing a web server on an Android phone, I started toying with the idea that I had this ARM-based, 2GB RAM, Linux-like device with Internet connectivity which must be more than enough for a simple webcounter-like application. After a few weeks of tinkering, here it is!

<!-- more -->


## Table of Contents

* [Motivation](#motivation)
   * [Why even keep anything?](#why-even-keep-anything)
   * [And then there is the data](#and-then-there-is-the-data)
   * [The (lack of) competition](#the-lack-of-competition)
* [Developing android-analytics](#developing-android-analytics)
   * [Basis](#basis)
   * [First iteration: Sinatra webapp](#first-iteration-sinatra-webapp)
   * [Second iteration: Nginx log parser](#second-iteration-nginx-log-parser)
   * [Third iteration: Adding a viewer](#third-iteration-adding-a-viewer)
   * [Fourth iteration: Adding an installation script](#fourth-iteration-adding-an-installation-script)
   * [Final architecture](#final-architecture)
* [Conclusion](#conclusion)


## Motivation

### Why even keep anything?

Before going into this whole thing, there's a very reasonable question to be answered: why do I even need to collect this data?

The answer is simple: I really don't, I just enjoy seeing it. Call it a [vanity metric](https://techcrunch.com/2011/07/30/vanity-metrics/), but I think its just _plain cool_ to know that someone half across the planet read something I wrote months ago (maybe it was just a crawler; I'll take it either way).

It should be no surprise, then, that Google Analytics always felt immensely overkill.

Its heartwarming to know that some nerd from Bhutan read one of my posts in the wee hours of the morning, but that is pretty much all I'm interested in. I could care less about Acquisition Treemaps, Audience Cohort Analysis or Behavior Flow. I'm not making those up: they're all real products available on Google Analytics. I have no idea of what any of those mean, yet I'm 100% sure I don't need them.

<%= render('/image-nostretch.*', src: '/blog/assets/images/2020/visitor_count.jpeg', alt: "Visitor counter from the 90s.", caption: "Visitor counter from the 90s.") %>

What I wanted was closer to the late 90s' visitor count GIF above (minus the embarrassment of publicity) than to the unsightly "Intersitial online advertising network conglomerate SEO dashboard" feeling of Google Analytics:

<%= render('/image.*', src: '/blog/assets/images/2020/ga.png', alt: "Google Analytics dashboard.", caption: "Google Analytics dashboard.") %>

In short, I wanted to geek out, not do advertisement arbitrage.

### And then there is the data

As aforementioned, Google Analytics is great, free, _and hosted by Google_.

They keep your data. I have no idea of what they do with that data, or even what exactly it is that their tracker is sending to their servers (judging from the number of articles showing how to keep the payload below the cap of 8kb, it must be a lot).

<%= render('/image-nostretch.*',
src: '/blog/assets/images/2020/ga_payload.png',
alt: "Google search results for 'google analytics payload size is too large'. 642,000 results.",
caption: "That's a lot of results.") %>

Apparently they often need over 8kb per request to feed their Lovecraftian "Audience Cohort Analysis" line of products. Fair enough, but I'm pretty sure that for my purposes, a several-kb payload is effectively using a sledgehammer to kill a fly.

By using Google Analytics I was willfully sending Google who-knows-what kind of data designed to build up people's advertising profile. The page views of my blog probably didn't help Google too much in that aspect, sure, but the principle of the whole thing still bothered me enough to do something about it.

### The (lack of) competition

There are a lot of software similar to Google Analytics out there. The most prominent is probably [Matomo](https://matomo.org/), often [posted on Hacker News](https://hn.algolia.com/?dateRange=all&page=0&prefix=true&query=matomo&sort=byPopularity&type=story). It is free, open source and self-hosted (with cloud offerings for a monthly fee).

I would happily use Matomo, but with it comes a conundrum:

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

### Fundamentals

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

### Fourth iteration: Adding an installation script

So far I was playing by ear; I knew more or less how to reinstall the project on a new device, but I knew that after some time my memory would fade and the process would become a painstaking trial-and-error mess.

I first compiled all the steps needed for this to work in the repo's README -- it took a total of [17 steps](https://github.com/lbrito1/android-analytics/commit/9487a54b37c727bdd60b7276469fc58a8fd0d47d#diff-04c6e90faac2675aa89e2176d2eec7d8) to get things running. Noticing that most of these steps could be automated, I wrote a [setup script](https://github.com/lbrito1/android-analytics/blob/master/bin/setup.sh) that should do most of the work. I tested it in a separate Android device to make sure it works -- hopefully it works for other people as well.

### Final architecture

When someone accesses one of my tracked pages, this is roughly what happens:


1. JavaScript on that page calls my domain (provided for free by [DuckDNS](https://www.duckdns.org/));
2. DuckDNS translates that address to my router's most recent IP;
3. My router receives that request and uses the NAT table to redirect it to my Android phone;
4. On Android, Nginx receives the request and either logs it if the request comes from the right place (my list of tracked pages), or does nothing otherwise;
5. A scheduled Cron job rotates Nginx logs and converts the "old" log into rows in a Postgresql table;
6. I open `<my-android-local-ip>:3000` on my desktop's browser and view the charts, maps etc.

This diagram shows those same steps, more or less:

<%= render('/image.*', src: '/blog/assets/images/2020/diagram.png', alt: "android-analytics diagram.", caption: "android-analytics diagram.") %>

I named the too (quite unimaginatively) android-analytics; code and set-up instructions are [available on Github](https://github.com/lbrito1/android-analytics).

### August 2021 Update

I managed to install Grafana on Termux by using [AnLinux](https://f-droid.org/en/packages/exa.lnx.a/); thus, the Viewer part of the project is no longer needed.

Also, by using [Ngrok](https://ngrok.com/) (free tier), the project now works if you're behind CGNAT, which is my case. No need for dynamic DNS or port forwarding as well.

## Conclusion

I used the Google Analytics analogy because that's the tool that most people are familiar with, and most people will immediately understand what this thing is about, which probably wouldn't happen if instead of saying this was a "simple Google Analytics alternative", I said it was a "log-based web analytics tool".

But saying this is a "Google Analytics replacement" is like saying that a bicycle is a replacement for a truck. Although they are both transportation modes, they're different in every other aspect. The thing is: sometimes you really need a truck, but a lot of times you just need to get from point A to point B, and a bike is more than enough. In fact, it is probably _better_: it is cheaper, easier to park and carry around, and has a smaller environmental footprint. This project is a bike: for some people, that's all they will need.

There's absolutely no need to use a mammoth like Google Analytics for a personal blog or pet project. Its more than wasteful -- you're offering free data to Google in exchange for a fancy dashboard so you can play I'm-SEO-master-at-Adcorp-LLC. Someone has to keep the data, of course, but I'd argue that a decentralized approach is much safer and probably more ethical than data monopoly by a single huge advertising company.

So what are the alternatives? There are a few competitors -- we already discussed that in a [previous section](#the-lack-of-competition). But then we have all this processing power just lying around, free and unused; we might as well make better use of it. Smartphones have amazing processing, networking and storage capabilities, yet for many reasons they turn old very quickly, which translates to getting sold (in the best case); shoved into oblivion in our designated e-junk clutter drawer; or just discarded.

It is just sad that we have these tiny slabs of processing power that could [navigate Man to the Moon and back thousands of times over](https://www.realclearscience.com/articles/2019/07/02/your_mobile_phone_vs_apollo_11s_guidance_computer_111026.html), and we can't seem to quite find any better occupation for them other than sitting in a dusty drawer for years or getting trashed. That is why even if it takes a little extra effort, I'd rather repurpose and reuse something I already own than subscribe to the fanciest new PaaS.
