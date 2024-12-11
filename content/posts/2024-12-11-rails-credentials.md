---
title: "Rails credentials: back to ENVs"
created_at: 2024-12-11 15:30:00 -0800
kind: article
published: true
tags:
  - rails
  - ruby
---

Since Rails 5, Rails has had an encrypted `credentials.enc` file which you can use to store secrets like API tokens and passwords.

I've come to see the shortcomings of this approach, and now I'm back to the traditional way of storing secrets on environment variables.

Although it might be a simpler solution when starting out a new project, the long-term problems of credentials.enc are significant. For example: with Rails' credentials, updating secrets is typically tied to redeploying of the app, which is much slower than simply restarting a VM (what you would do if you were using ENVs).

But the biggest drawback of using Rails' credentials is that it inevitably leads to having more than one source of truth for your project's secrets: eventually your project will have extra-Rails dependencies, and they obviously won't read from Rails' credentials. So you'll end up with some API keys defined in `credentials.enc`, and some others defined elsewhere, like a `.env`. Better, then, to use `.env` from the start, and use something like Infisical for management and team access.
