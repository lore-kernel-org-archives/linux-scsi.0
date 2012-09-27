From: Theodore Kilgore <kilgota-StTmvpUuumi84Ug3WP2LR/zrsOk5h0fN@public.gmane.org>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in
 usb3 port
Date: Thu, 27 Sep 2012 18:21:12 -0500 (CDT)
Message-ID: <alpine.LNX.2.00.1209271758310.12216@banach.math.auburn.edu>
References: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA@mail.gmail.com> <Pine.LNX.4.44L0.1209271447340.1230-100000@iolanthe.rowland.org> <CAEG-z29dU=C49u7_Hi--dKLLf4OuS_LgB3azR4ui4ngu8dt-bQ@mail.gmail.com> <20120927200433.GB27721@xanatos>
 <CAEG-z2-Z9ojSYatHAq-71EjM36uieL3rrn1V4+hsZAz5murGTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAEG-z2-Z9ojSYatHAq-71EjM36uieL3rrn1V4+hsZAz5murGTA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adrian Sandu <dexter-aBDqsGrG5hJxuZdfhUSrJg@public.gmane.org>
Cc: Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


Adrian,

I think that the suggestion about checking the power supply, the cabling, 
the grounding screws, and anything of like nature that has been omitted 
from this list is a very good idea. If successful it would eliminate 
the problem for you, as well as resolving the mystery. Unresolved 
mysteries are unpleasant for the user, and at least equally unpleasant 
for a developer. 

I have seen hardware do really weird things, myself. As a trivial example, 
once a local computer shop gave me a motherboard which had been returned 
because of booting problems. I was told that it had been brought in twice 
by the customer. No problem had been detected in the shop; they had 
replaced it to make a customer happy. I brought the board home. It was a 
hot summer day. I put it on the floor, hooked up a spare power supply, and 
it booted. No problem. I left it sitting there overnight. The next 
morning, I tried it again. Dead. But in the evening it came to life again. 
Guessing, I looked at the solder joints under the power connector on the 
board. One of them looked suspicious. So I fired up the soldering iron and 
put a dab of fresh solder on it. After that, the board was in use for 
years and never had the booting problem again. The reason that the problem 
was not detected was that it was the middle of the summer in Alabama, and 
when the computer was brought to the shop it was put in a car for the 
trip. The board got warm enough for the solder in that joint to expand 
enough for startup, while en route to the shop.

Thus, I definitely do encourage you to check for hardware or cabling 
problems before deciding to buy additional equipment as a workaround. 


Good luck,

Theodore Kilgore


On Thu, 27 Sep 2012, Adrian Sandu wrote:

> > They're the same chipset.  There's minor differences in the PCI
> > capabilities, but not much else.  It could be something electrically
> > wrong with the AsRock system, I suppose.  That's possible if you see
> > the errors popping up erratically.
> >
> > Any chance you can exchange the AsRock system?
> 
> Nope... I have it for more than 1 year and I kinda' need it even if
> the usb3 won't work... at least I can use the 2 ports to dirrectly
> connect 2 drives...nothing else is wrong and I wouldn't of known if I
> wouldn't of got these hubs...
> 
> My only solution if no more debugging can be done is to get a nas a
> put the drives in it...
> 
> Maybe it's the drives fault somehow ? maybe we should mail wd ?
> manhattan's fault ? via ? :) There must be someone/someway/somehow
> that can analyze it in someway and say what is wrong ..
> 
> Still weird..I'll try on another laptop tomorrow or so ( a dell
> inspiron with an usb3 port .. dunno what usb3 root chipset it has )
> 
> -- 
> You received this message because you are subscribed to the Google Groups "USB Mass Storage on Linux" group.
> To post to this group, send email to usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf4b8TPpkIZ3Q@public.gmane.org
> To unsubscribe from this group, send email to usb-storage+unsubscribe-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf4b8TPpkIZ3Q@public.gmane.org
> For more options, visit this group at http://groups.google.com/a/lists.one-eyed-alien.net/group/usb-storage/?hl=en.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
