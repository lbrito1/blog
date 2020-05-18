---
title: Figuring out the Nvidia x Linux puzzle
created_at: 2020-05-16 16:48:00 -0300
kind: article
published: true
tags:
- Linux
- Ubuntu
- Nvidia
---

<%= render('/image.*', src: '/blog/assets/images/2020/power.png', alt: "Ubuntu power consumption chart.", caption: "Ubuntu's power rate over time.") %>

I've struggled with some kind of problem with Nvidia graphics cards on Linux since forever.

Most commonly, an external monitor wouldn't work or the dedicated card would refuse to power off when it should.

The latter problem -- a power-hogging discrete Nvidia card not turning off when it isn't needed, specifically in [Optimus](https://www.wikiwand.com/en/Nvidia_Optimus)-enabled laptops -- has consistently haunted me throughout the years. At least in my experience, this problem is in that sweet spot of things that are definitively annoying and kind of inconvenient, but complicated enough not to be worth the several work-hours needed to definitively solve it.

<!-- more -->

I know that I'm not alone here, as other people over the internet have said things like _["I've been pulling my hair out for the past few hours trying to configure my graphics drivers on my laptop"](https://forum.manjaro.org/t/solved-bumblebee-issues-with-bbswitch/70137)_. I've also not been a total sloth about this: although I have tried many times in the past to fix this, I've consistently found myself thinking "okay, _now_ this is fixed", only to a few hours/days later notice that my laptop battery was drained in an hour and the problem was back. I actually re-wrote a significant part of this post because when I thought I was finished, my Nvidia card started turning on again and I had to do more research.

Taking advantage of the extra time in my hands due to the Covid-19 city-wide lockdown, I decided to persistently look for a solution to this issue. This guide is just a documentation of this process. I use Ubuntu, but similar steps should be valid with whatever distro you're using. Also, some or many of the steps might not actually be necessary - they're just what happened to finally work in my case.

### 1. Install the proprietary Nvidia drivers

Ubuntu uses the open-source Nouveau driver for Nvidia cards, which doesn't play well with Optimus-enabled laptops. Let's install the proprietary Nvidia driver.

First, find out what's the recommended Nvidia driver:

<div class="highlight"><pre><code class="language-bash">
$ ubuntu-drivers devices

== /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0 ==
modalias : pci:v000010DEd00002191sv00001462sd00001274bc03sc00i00
vendor   : NVIDIA Corporation
driver   : nvidia-driver-435 - distro non-free
driver   : nvidia-driver-440 - distro non-free recommended
driver   : xserver-xorg-video-nouveau - distro free builtin

== /sys/devices/pci0000:00/0000:00:14.3 ==
modalias : pci:v00008086d0000A370sv00008086sd00000034bc02sc80i00
vendor   : Intel Corporation
manual_install: True
driver   : backport-iwlwifi-dkms - distro free
</code></pre></div>

Then install it:

<div class="highlight"><pre><code class="language-bash">
$ sudo apt install nvidia-440
</code></pre></div>

Another option is to pick the driver in the Additional Drivers tab of the `Softwares & Updates` tool:

<%= render('/image.*', src: '/blog/assets/images/2020/2020-05-16-05-04.nvidia.png', alt: "Nvidia proprietary driver option in Ubuntu's Additional Drivers menu.", caption: "Nvidia proprietary driver option in Ubuntu's Additional Drivers menu.") %>

Nvidia's proprietary driver lets you choose if you want to use the dedicated or integrated GPU, which you can try setting:

<%= render('/image.*', src: '/blog/assets/images/2020/nvidia-setting.png', alt: "Nvidia proprietary driver's GPU selection menu.", caption: "Nvidia proprietary driver's GPU selection menu.") %>

Now if you're lucky this might be enough. Check the power usag using Ubuntu's `Power Statistics` tool or `powertop`: if the Nvidia card is successfully turned off, then typical power usage is somewhere between 8-14W. If, like me, this changed nothing in your power usage, read on.

### 2. Install and configure bbswitch

Although Nvidia's proprietary driver allows selecting between integrated and dedicated cards, in my experience that setting has had no effect at all, with both cards always being powered on anyway.

`bbswitch` is a tool that allows you to select which card you want your system to use. Ubuntu has the bbswitch-dkms package available:

<div class="highlight"><pre><code class="language-bash">
$ sudo apt install bbswitch-dkms
</code></pre></div>

Then configure it to always turn off the discrete card by creating the following file:

<div class="highlight"><pre><code class="language-bash">
$ cat /etc/modprobe.d/bbswitch.conf
options bbswitch load_state=0
</code></pre></div>

### 3. Blacklist Nouveau driver

According to [this Stackoverflow answer](https://askubuntu.com/a/1044095/463850), there seem to be at least a couple of bugs that result in Ubuntu trying to load the Nouveau module even if you're using a proprietary Nvidia driver. When that happens, the discrete Nvidia GPU turns on and starts hogging a lot of power.

Blacklisting the Nouveau module solved this issue for me:

<div class="highlight"><pre><code class="language-bash">
$ sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
$ sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
</code></pre></div>

Restart and confirm that the right driver is loaded:

<div class="highlight"><pre><code class="language-bash">
$ gpu-manager | grep nouveau
Is nouveau loaded? no
Is nouveau blacklisted? yes
</code></pre></div>

### 4. Blacklist some Nvidia modules

Even after the above, my system kept turning on the nvidia card seemingly at random. I found [this post](https://github.com/Bumblebee-Project/Bumblebee/issues/951) in the Bumblebee issue tracker to be extremely helpful:

>"bumblebee can turn the nvidia card off when it starts, but as soon as the nvidia module is loaded, it loads nvidia_drm, which links to drm_kms_helper and then bumblebee can't remove the nvidia modules. This means that bumblebee can't turn off the nvidia card when optirun terminates. To fix this, I added "alias nvidia_drm off" and "alias nvidia_modeset off" to my conf file in /etc/modprobe.d."

This is the file created by the OP:

<div class="highlight"><pre><code class="language-bash">
$ cat /etc/modprobe.d/nvidia.conf

blacklist nvidia
blacklist nvidia_drm
blacklist nvidia_modeset
alias nvidia_drm off
alias nvidia_modeset off
</code></pre></div>

After creating this file and restarting, my system was finally using only the Intel integrated card. Hopefully this time it'll stay that way.

### Results

Here's a chart of my laptop's power rate:

<%= render('/image.*', src: '/blog/assets/images/2020/power.png', alt: "Ubuntu power consumption chart.", caption: "Ubuntu's power rate over time.") %>

Using the integrated Intel GPU, the rate fluctuates around 10W. When the Nvidia card kicks in, which is what was going on around the middle of the chart, it jumps to 40W+.

### References

* [https://linuxconfig.org/how-to-install-the-nvidia-drivers-on-ubuntu-18-04-bionic-beaver-linux]()
* [https://github.com/Bumblebee-Project/bbswitch]()
* [https://github.com/Bumblebee-Project/Bumblebee/issues/951]()
* [https://turlucode.com/optimus-bbswitch-on-ubuntu-18-04/]()
