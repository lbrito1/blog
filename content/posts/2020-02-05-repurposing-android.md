---
title: Repurposing an old Android phone as a Ruby web server
created_at: 2020-02-05 09:24:41 -0300
kind: article
published: true
---

<%= render('/image.*', src: '/blog/assets/images/2020/old-android.jpg', alt: "Old smartphones on a desk.", caption: "CC-BY Carlos Varela, https://www.flickr.com/photos/c32/7755470064") %>

Do you have an old Android phone? Sure you do! There's a mind-blowing amount of electronic waste of all kinds, and with the average person in developed countries [discarding their phones every couple of years](https://www.cnbc.com/2019/05/17/smartphone-users-are-waiting-longer-before-upgrading-heres-why.html), pretty much everyone has at least one old smartphone lying around.

I had an old Motorola G5 Cedric gathering dust, so I decided to do something with it -- it is now running a Puma web server with a simple Sinatra webapp.

This is a short tutorial on how to repurpose an Android device as a web server -- or any number of different things, really.

<!-- more -->

## 1. Install Termux

First of all we need a Linux environment in our phone. Termux is a terminal emulator and Linux environment for Android. It's available on Google Play Store. No additional configuration is needed after installation.

## 2. Set up SSH

You won't want to type a lot of commands into a tiny touchscreen, so let's set up ssh so that we can log into Termux remotely.

There are [several ways](https://wiki.termux.com/wiki/Remote_Access) of doing this, but I've found that the easiest way is through a software called **Dropbear**:

#### Android
<div class="highlight"><pre><code class="language-bash">
pkg upgrade
pkg install dropbear
</code></pre></div>

You can use password-based authentication or public key authentication. You should use key-based authentication, but for testing purposes password-based is easiest. Run this on Android:

#### Android
<div class="highlight"><pre><code class="language-bash">
passwd
New password:
Retype new password:
New password was successfully set.
</code></pre></div>

Go ahead and test the connection:

#### Desktop
<div class="highlight"><pre><code class="language-bash">
ssh android-ip-address -p 8022
</code></pre></div>

## 3. Set up static IP address on Android

Go to wifi settings, disable DHCP and assign an IP address for your phone.

This is necessary so that your router won't assign a new IP address to your phone every few hours/days, which would make configuration a lot harder.

## 4. Install Ruby, Bundler, Sinatra and Puma

Sinatra is a lightweight web application framework, and Puma is a web server.

Ruby is, well Ruby!

Of course, Sinatra and Puma are just suggestions -- you could even use full-blown Rails on your phone, as described in [this neat tutorial](https://mbobin.me/ruby/2017/02/25/ruby-on-rails-on-android.html). Just [don't use WEBRick](https://devcenter.heroku.com/articles/ruby-default-web-server#why-not-webrick), the default Rails web server in development -- it is single-process, single-threaded and thus not suitable for production environments (it is fine for small experiments though).

#### Android
<div class="highlight"><pre><code class="language-bash">
pkg install ruby
gem install sinatra puma
</code></pre></div>

## Install nginx

nginx is a web server, reverse-proxy and load balancer. Although most useful in multi-server setups where it is used to distribute requests among different instances, nginx is also a good idea in our setup because of the embedded DDoS protection and static file serving that it provides.

#### Android
<div class="highlight"><pre><code class="language-bash">
pkg install nginx
</code></pre></div>

Now the slightly tricky part is configuring nginx to work with Puma. [This gist](https://gist.github.com/ctalkington/4448153) is a pretty good start -- copy & paste `nginx.conf` and change `appdir` to your webapp's root dir. In my case, for example, that would be `/data/data/com.termux/files/home/android-sinatra`.

## Set up port forwarding

You probably want your web server to be accessible through the internet, so you'll have to set up port forwarding in your router to redirect incoming requests to your public IP address to your brand new Android web server.

How exactly to do this varies depending on your router. [Here's](https://www.noip.com/support/knowledgebase/general-port-forwarding-guide/) a pretty good tutorial to get you started.

## Configure a dynamic dns

Most people have dynamic public IP addresses. In these cases it is useful to set up a dynamic dns (DDNS) service, which provides you with a static domain name that redirects automatically to whatever your public IP address is at that moment.

There are few free services that provide DDNS nowadays; I'm using [no-ip](https://www.noip.com/) and it has been okay so far. You do have to "renew" your domain every month though.

After setting up a DDNS, you'll have to configure your router as well so that it periodically notifies the DDNS service with your current IP address. Again, how exactly to do this depends on your router model.

## Hello world!

<%= render('/image.*', src: '/blog/assets/images/2020/android-web-server.jpg', alt: "Puma and nginx running on a Motorola G5.", caption: "Puma and nginx running on a Motorola G5.") %>
