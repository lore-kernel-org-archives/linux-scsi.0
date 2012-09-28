From: Adrian Sandu <dexter@d3xt3r01.tk>
Subject: Re: [usb-storage] Re: usb3 fails to write when using usb3 hub in usb3 port
Date: Fri, 28 Sep 2012 09:47:25 +0300
Message-ID: <CAEG-z2-vNfQh2yHnu2LqfCjP06LzULHU3vUWoVp-eetAzNbFpg@mail.gmail.com>
References: <CAEG-z2-QqRs4rK58BsPafnqLuQKXxHCGE_Q5R-WkhpPGNz1RoA@mail.gmail.com>
 <Pine.LNX.4.44L0.1209271447340.1230-100000@iolanthe.rowland.org>
 <CAEG-z29dU=C49u7_Hi--dKLLf4OuS_LgB3azR4ui4ngu8dt-bQ@mail.gmail.com>
 <20120927200433.GB27721@xanatos> <CAEG-z2-Z9ojSYatHAq-71EjM36uieL3rrn1V4+hsZAz5murGTA@mail.gmail.com>
 <alpine.LNX.2.00.1209271758310.12216@banach.math.auburn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2I1Grq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Sep 2012 02:47:46 -0400
Received: by pbbrr4 with SMTP id rr4so4707311pbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 27 Sep 2012 23:47:45 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.00.1209271758310.12216@banach.math.auburn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, linux-scsi@vger.kernel.org

>
> Adrian,
>
> I think that the suggestion about checking the power supply, the cabling,
> the grounding screws, and anything of like nature that has been omitted
> from this list is a very good idea. If successful it would eliminate
> the problem for you, as well as resolving the mystery. Unresolved
> mysteries are unpleasant for the user, and at least equally unpleasant
> for a developer.
>
> I have seen hardware do really weird things, myself. As a trivial example,
> once a local computer shop gave me a motherboard which had been returned
> because of booting problems. I was told that it had been brought in twice
> by the customer. No problem had been detected in the shop; they had
> replaced it to make a customer happy. I brought the board home. It was a
> hot summer day. I put it on the floor, hooked up a spare power supply, and
> it booted. No problem. I left it sitting there overnight. The next
> morning, I tried it again. Dead. But in the evening it came to life again.
> Guessing, I looked at the solder joints under the power connector on the
> board. One of them looked suspicious. So I fired up the soldering iron and
> put a dab of fresh solder on it. After that, the board was in use for
> years and never had the booting problem again. The reason that the problem
> was not detected was that it was the middle of the summer in Alabama, and
> when the computer was brought to the shop it was put in a car for the
> trip. The board got warm enough for the solder in that joint to expand
> enough for startup, while en route to the shop.
>
> Thus, I definitely do encourage you to check for hardware or cabling
> problems before deciding to buy additional equipment as a workaround.
>
>
> Good luck,
>
> Theodore Kilgore
>
>
> On Thu, 27 Sep 2012, Adrian Sandu wrote:
>
>> > They're the same chipset.  There's minor differences in the PCI
>> > capabilities, but not much else.  It could be something electrically
>> > wrong with the AsRock system, I suppose.  That's possible if you see
>> > the errors popping up erratically.
>> >
>> > Any chance you can exchange the AsRock system?
>>
>> Nope... I have it for more than 1 year and I kinda' need it even if
>> the usb3 won't work... at least I can use the 2 ports to dirrectly
>> connect 2 drives...nothing else is wrong and I wouldn't of known if I
>> wouldn't of got these hubs...
>>
>> My only solution if no more debugging can be done is to get a nas a
>> put the drives in it...
>>
>> Maybe it's the drives fault somehow ? maybe we should mail wd ?
>> manhattan's fault ? via ? :) There must be someone/someway/somehow
>> that can analyze it in someway and say what is wrong ..
>>
>> Still weird..I'll try on another laptop tomorrow or so ( a dell
>> inspiron with an usb3 port .. dunno what usb3 root chipset it has )

The only thing I can do is buy other usb3 cables :| It's weird to
think that 5 drives ( 2 bought last week or so from 2 different stores
( 1 wd and 1 seagate ), the other 3 are 2 WDs and 1 verbatim bought
from different shops each (I am a "backup nazzi") ) are all having
problems !
