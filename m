From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: SG_IO ioctl (was: mode sense blacklist how)
Date: 21 Nov 2003 13:51:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069447873.14422.229.camel@patrh9>
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
	 <1069345927.6663.27.camel@patrh9>  <3FBD679C.5010405@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:20984 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S262794AbTKUUv5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2003 15:51:57 -0500
In-Reply-To: <3FBD679C.5010405@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug G:

> The SCSI command timeout should bring things back but often at the
> expense of a bus reset (on SPI) which can have some nasty side effects
> (e.g. if your root file system is on a disk on the same SPI bus).

Aye.  From reset-issued-Before-next-command I get nasty side effects in
SCSI over IDE (aka ATAPI), SCSI over USB, SCSI over FireWire ...

> > more prominent device names like /dev/hdd and /dev/scd0
> > in place of less prominent /dev/sg$n names ...
> ...
> trade-off ...
> Pros: ... - ... - ...
> Cons: ... - ... - ... - ... - ... - ...
> more "cons" will come to light ...
> probably enough ... to give the cdrecord author pause for thought.

Wow.  Prompt, incisive.  Thank you offline to this doc I will link folk.

http://marc.theaimsgroup.com/?l=linux-scsi&m=106937826522932

List:     linux-scsi
Subject:  SG_IO ioctl (was: mode sense blacklist how)
Date:     2003-11-21 1:17:16
 
> > Sorry I'm too much of a kernelnewbie to guess confidently the full
> > implications of "not interruptible".  Does "not interruptible" mean
> > timeouts don't work, or does "not interruptible" mean that only timeouts
> > work, or does "not interruptible" mean that only timeouts and resets but
> > not SIGINT of the calling process works ...
> 
> "Linux Kernel Development" Robert Love ISBN 0-672-32512-8 covers
> lk 2.6 pretty well including these issues. [Note in passing: the
> book makes no mention of the SCSI or ATA subsystems or aio:-(]

Thanks for the link, I will look again, I should manage to click thru to
hardcopies of same or similar title within twenty-four hours.

Perhaps I should have mentioned I am only a Linux kernelnewbie, not a
nano"kernel newbie", so I've found a few much-linked Linux books
frustratingly waste many words telling me again what I already know.

> "not interruptible" in this context means that signals (e.g.
> control-C from the keyboard or kill-9) have no effect while
> waiting for the SCSI response.

My Terminal Ctrl+C becomes SIGINT and kills my main user thread and user
process but doesn't affect the kernel thread serving me?  Ever?  Or only
no effect til that thread tries to return?

> ** ... if sg (plus st + osst) had sysfs visibility ...

This I'm too new to grok but I see others answering already.

Pat LaVarre


