---
title: Rails credentials
created_at: 2024-08-22 15:30:00 -0800
kind: article
published: false
tags:
  - misc
---

Since Rails 5, Rails has had an encrypted credentials.enc file which you can use to store secrets like API tokens and passwords.

I've come to see the shortcomings of this approach, and now I'm back to the traditional way of storing secrets on environment variables.

Although it might be a simpler solution when starting out a new project, the long-term problems of credentials.enc are significant.

Specifically, in a reasonably mature app with a working CD, changing secrets will typically need a deploy of the app. In theory you could create a separate CD action only for changing secrets which either gets called manually through the CD UI or listens to changes to credentials.enc, but lets be honest, no one has time for that, and it kind of defeats the purpose of simplicity in the whole thing.

Traditional env vars, even more so with nice secrets management platforms like Infisical, involve simple VM restarts, which are much, much faster and less risky.
