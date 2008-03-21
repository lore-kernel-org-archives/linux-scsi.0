From: peter fuerst <post@pfrst.de>
Subject: Re: [PATCH] WD33C93: let platform stub override no_sync/fast/dma_mode
Date: Sat, 22 Mar 2008 00:45:03 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0803220038510.622@Indigo2.Peter>
References: <20080321212543.6F769C2DF8@solo.franken.de>
 <Pine.LNX.4.58.0803212302190.564@Indigo2.Peter> <20080321230424.GA31455@alpha.franken.de>
Reply-To: post@pfrst.de
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.pearl-online.net ([62.159.194.147]:6986 "EHLO
	mail1.pearl-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbYCUXyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Mar 2008 19:54:44 -0400
In-Reply-To: <20080321230424.GA31455@alpha.franken.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org, ralf@linux-mips.org, James.Bottomley@HansenPartnership.com



On Sat, 22 Mar 2008, Thomas Bogendoerfer wrote:

> Date: Sat, 22 Mar 2008 00:04:24 +0100
> From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> To: peter fuerst <post@pfrst.de>
> Cc: linux-scsi@vger.kernel.org, linux-mips@linux-mips.org,
>      ralf@linux-mips.org, James.Bottomley@HansenPartnership.com
> Subject: Re: [PATCH] WD33C93: let platform stub override
>     no_sync/fast/dma_mode
>
> On Fri, Mar 21, 2008 at 11:20:07PM +0100, peter fuerst wrote:
> > ...
>
> this hack is IMHO no longer needed. If the user wants to override no_sync
> via kernel command line, it works as before. If the user doesn't no_sync
> will be 0 (now set in sgiwd93.c before calling wd33c93_init()) and the
> driver will try to do sync transfers for all devices. It works like before.

It works cleaner than before :-)

> Or did I miss something ?

No. As already said, just forget it, i missed to look at the whole patch in time.

>
> Thomas
>
> --
> Crap can work. Given enough thrust pigs will fly, but it's not necessary a
> good idea.                                                [ RFC1925, 2.3 ]
>
>
