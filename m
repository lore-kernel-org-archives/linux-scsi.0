From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: TMSCSIM [2.6]
Date: Sat, 29 Nov 2003 10:46:24 +0100 (CET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0311291030500.1672-100000@poirot.grange>
References: <3FC7FC89.4060601@yk.rim.or.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:23963 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S263751AbTK2JrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 04:47:08 -0500
In-Reply-To: <3FC7FC89.4060601@yk.rim.or.jp>
List-Id: linux-scsi@vger.kernel.org
To: Chiaki <ishikawa@yk.rim.or.jp>
Cc: linux-scsi@vger.kernel.org, Thorsten Leemhuis <Thorsten_Leemhuis@gmx.de>, gl@dsa-ac.de

On Sat, 29 Nov 2003, Chiaki wrote:

> Also, I disabled kernel preemption after reading your post.
>  From my .config:
>    # CONFIG_PREEMPT is not set

Ok, then it worked (except for that misterious first try). Can you switch
preemption on again, so we can check for sure that it's my last
modification, that fixed your problem and not switching preemption off.

> I looked at the address where Oops occurred on the screen.
> It was slightly different from the one reported earlier.  Obviously,
> the patch changed the absolute addresses. However, the symptoms (stack
> trace, with a duplication.) was essentially the same from the report I
> gave earlier.

That is very strange. Let's keep an eye on this...

> So there *could* be a timing related race or somthing that might
> trigger a problem in a rare situation.

You load the driver always on boot, right? So, consitions are always more
or less the same...

> kernel test versions now and then. Oh, maybe I should test HP DAT
> drive, too.).

Yes, please do. Thorsten still has problems burning CDs on a tmscsim
attached CDRW. You don't have one to test, do you?

> PS: now that the driver seems to be in better shape, you might want to
> bump the driver version number  reported in the banner,
> "Tekram DC390/AM53C974 PCI SCSI Host Adapter, Driver Version 2.0f
> 2000-12-20".

Yep. Kurt, Christian, shall I increment the version number (2.0g / 2.1a?),
adding a Changelog entry? Also, how shall it be maintained now, until it
is included in the stock 2.6 (hopefully)? Is there a linux-scsi tree,
where this driver could be merged in, or just an ftp site, where the patch
could be uploaded? I am not using BK (don't think it would make much sense
with a 56K modem dial-up:-)).

> PPS: also someone might want to run
> 	indent -kr -i8
> on the source files after the cleanup (or before cleanup).

No, wouldn't do that. It would unnecessarily blow the patch up...
Although, I didn't really follow the original indentation everywhere, but
I wouldn't chenge it all just for the sake of it. The patch already has
more than enough "non-functionality-related" modifications.

Thanks
Guennadi
---
Guennadi Liakhovetski


