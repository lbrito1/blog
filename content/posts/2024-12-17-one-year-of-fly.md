---
title: One year of Fly
created_at: 2024-12-17 10:33:44 -0800
kind: article
published: true
tags:
  - devops
---

<%= render('/post_hero.*', src: '/blog/assets/images/2024/fly-sm.webp', alt: "Hot air balloon.", caption: "") %>


It's been a year since I moved my company's infrastructure away from AWS. Being in a small team that was unfamiliar with AWS, it was the right move. Having used Fly.io for side projects before, I went with them as our new host. While not perfect, the experience has been overall a great success.

The main motivation was how simple and hands-off Fly is, especially when compared with its polar opposite, AWS. There was quite a lot of infra cost savings as well. Here's a quick summary of my overall experience and feeling on them.

<!-- more -->

## Good

* The CLI is great, making things like expanding disk size or adding RAM very simple to do.
* They're very open to adding new features upon request in the community forum. I've had turnarounds of as fast as a couple of days, from asking for something in the forum to having it deployed in a new minor version in their CLI.
* Related to the above; they are constantly adding new features, so there's a real sense of improvement going on.
* Most of the more annoying aspects of networking and security are hidden away from you.
* Their VMs run on Docker, so its fairly easy to debug something, add new software etc.

## Underwhelming

* Outages are frequent, although rarely catastrophic. They seem to do their best to be informative and helpful when they happen, and don't seem to hide when they're in trouble. Having worked for two years at AWS and seen two full-scale IAD outages, this doesn't rattle me too much.
* Premium support is hit-and-miss, sometimes you get super fast and insightful responses, sometimes you get days-late responses that aren't very useful.


## Bad

* Lackluster IAM. Things like adding an API token with limited scope is a pain. They use  [Macaroons](https://en.wikipedia.org/wiki/Macaroons_(computer_science)) for token attenuation, and I for one find it awful to work with. Maybe I'm just an idiot.
* Unmanaged Postgres clusters can be daunting, and there is little support. I've had a few "we don't know what's going on" responses to bugs I've encountered, but even then in general they have helped me with a path forward.

They're probably not for everyone. They move really fast, and in often incongruous, baffling ways. For example, their Postgres offering is unmanaged ([This Is Not Managed Postgres](https://fly.io/docs/postgres/getting-started/what-you-should-know/)), and they've been saying for a long time that things would stay that way. Then earlier this year they started offering managed Postgres through a partner, Supabase. And now they're saying they are going to offer [managed Postgres](https://community.fly.io/t/fly-managed-mysql-private-beta/21461/26) themselves soon. Most of these comms are scattered in random unrelated threads in the forum.

All in all I approve of Fly and am satisfied with them so far. They're probably not the bargain discount they were a couple of years ago, but they are also much more mature and reliable.
