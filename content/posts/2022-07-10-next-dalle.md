---
title: DALL·E minis of the future won't be fun
created_at: 2022-07-10 15:30:00 -0800
kind: article
published: true
tags: [misc, ai]
---

<%= render('/post_hero.*', src: '/blog/assets/images/2022/stalin-drone-sm.jpg', alt: "", caption: "") %>

I've been playing with [dalle-mini](https://huggingface.co/spaces/dalle-mini/dalle-mini) the last few weeks. Part of what makes it fun to play with are the bizarre and obtuse outputs. They reached that sweet spot between laughably bad and frighteningly perfect: they're good enough to be understood and enjoyed, basically.

I think that incompleteness is part of what makes it so amusing to toy with these things, and conversely what will make future versions much less fun.

<!-- more -->


Dalle-mini is, as the name implies, much smaller than dall-e, using 0.4 billion parameters instead of 12 billion. Dall-e isn't entirely publicly available so dall-e mini is more of an reconstruction/reverse engineering effort rather than just a toned down version (extracted from [their website](https://wandb.ai/dalle-mini/dalle-mini/reports/DALL-E-Mini-Explained--Vmlldzo4NjIxODA#the-dall-e-experiment)).

Future iterations will be far more impressive. Consider the [difference between dall-e and dall-e 2](https://simplified.com/blog/ai/dall-e-1-vs-dall-e-2/), for instance:

<%= render('/image.*', src: '/blog/assets/images/2022/dalle-1-2.jpg', alt: "", caption: "") %>

As they inch closer to perfection -- perfection being "indistinguishable from human-made", by the way -- these models will surely be widely commercialized, and eventually easily available.

I think playing with a near-perfect "future dalle" will be as fun as comparing baking soda packaging at the grocery store. These models will become just another tool. I can see them being widely used to generate birthday card designs, obliterating the probably small niche of birthday card designers. I can't see them being the next Bruegel the Elder or Hieronymus Bosch.

As these models become increasingly commoditized, they will blend in with the art industry and eventually be forgotten by the public like all novelties eventually are. An AI-generated corporate décor at the office will be as bland and uninteresting as a human-made one. Eventually the distinction won't matter. Right now, though, it is hard to mistake a dalle-mini output as being created by a human, and I think that is part of its appeal.

Think about the sample inputs that OpenAI gives their model, like "an astronaut riding a horse in photorealistic style". We don't really need a near-perfect AI model to amuse ourselves with that thought -- our brains are enough.

Perhaps something similar or analogous happened with videogames. Early 3D games would leave much up to the imagination of the player; the closer games get to perfect graphical realism, however, the more boring and uninteresting they seem (to me). I think the wave of indie games with intentionally "bad" graphics is no accident - there is an undeniable appeal of leaving things out.

<%= render('/image.*', src: '/blog/assets/images/2022/obra-dinn.jpg', alt: "Screenshot of the video game Return of the Obra Dinn, showing a black-and-white 3D environment.", caption: "Return of the Obra Dinn (https://en.wikipedia.org/wiki/Return_of_the_Obra_Dinn)") %>

This boils down to what I think is a fundamental misconception about AI held by many people. AI doesn't (and cannot) _create_ anything, it just mixes and matches (in very smart ways) things created by humans. The training sets are immense, and the techniques are increasingly complex, but unless there is some radical, foundational pivot, AI is and will be ultimately derivative of human creations. And derivation is ultimately boring. Right now most people still don't quite grasp this ontological difference between "real" intelligence, which creates things, and AI, which doesn't (some will claim there really is no difference and humans must operate in the same way, but I won't get into that).

This misunderstanding leads to pretty funny situations, like the Google engineer that [claimed a chatbot was sentient](https://www.washingtonpost.com/technology/2022/06/11/google-ai-lamda-blake-lemoine/). [Its not](https://www.youtube.com/watch?v=iBouACLc-hw). It mixes texts in a smart way. I think people will eventually catch up to this, and when that happens, the improved "mini-dalle" of the future won't be nearly as interesting or amusing as its less perfect predecessors.
