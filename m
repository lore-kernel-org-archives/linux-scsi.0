From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] mode sense blacklist how
Date: 20 Nov 2003 09:32:07 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069345927.6663.27.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
	 <1068838908.2852.34.camel@patrh9>
	 <1069246502.3fbb6826955dd@webmail.netregistry.net>
	 <1069261377.2867.37.camel@patrh9>  <3FBBFDFB.9010406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:2211 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261957AbTKTQcq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Nov 2003 11:32:46 -0500
In-Reply-To: <3FBBFDFB.9010406@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: dmitrik@users.sourceforge.net, linux-scsi@vger.kernel.org

> > > The only really important question IMHO is
> > > how come SG_IO is not interruptible.
> >
> > Yes, now being pursued by Doug G in this thread.
>
> block/scsi_ioctl.c...
> I suspect ... cannot interrupt the sg_io... blk_do_rq...
> Perhaps someone could enlighten me (and I could document it).
>
> Further it looks like the SCSI_IOCTL_SEND_COMMAND is not
> interruptible either. See scsi_wait_req() in scsi_lib.c .

Open question I see.

> Apologies in advance for each reboot these experiments force on you.
> ...
> sg.c .... coping with orphaned SCSI responses from user killed
> processes requires a lot of logic ...

Ouch.

Designing an lk 2.6 user app to recommend more prominent devie names
like /dev/hdd and /dev/scd0 in place of less prominent /dev/sg$n names
thereby steers people into using the less robust pass thru of SG_IO via
block/scsi_ioctl.c.

> I suspect ... cannot interrupt ...

Sorry I'm too much of a kernelnewbie to guess confidently the full
implications of "not interruptible".  Does "not interruptible" mean
timeouts don't work, or does "not interruptible" mean that only timeouts
work, or does "not interruptible" mean that only timeouts and resets but
not SIGINT of the calling process works ...

I will return here with answers if I find them faster than people here
give them to me.

Pat LaVarre

P.S. Another open netiquette question is when we rename this thread.


