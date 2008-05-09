From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Thu, 08 May 2008 19:05:57 -0500
Message-ID: <1210291557.3114.74.camel@localhost.localdomain>
References: <481D9C69.8080902@garzik.org>
	 <1209914732.16283.27.camel@localhost.localdomain>
	 <1209915560.16283.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41558 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932914AbYEIAGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 May 2008 20:06:03 -0400
In-Reply-To: <1209915560.16283.31.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sun, 2008-05-04 at 10:39 -0500, James Bottomley wrote:
> On Sun, 2008-05-04 at 10:25 -0500, James Bottomley wrote:
> > On Sun, 2008-05-04 at 07:22 -0400, Jeff Garzik wrote:
> > > See attached files for additional config detail.
> > > 
> > > Platform summary:  AMD64 2x2 (== 4 cores), Fedora 8/x86-64
> > > 
> > > Driver 'sr' needs updating - please use bus_type methods
> > > BUG: unable to handle kernel NULL pointer dereference at 00000000000005d8
> > > IP: [<ffffffff8025e10c>] get_page_from_freelist+0x43/0x573
> > > PGD 7e90f067 PUD 7edbc067 PMD 0
> > > Oops: 0000 [1] SMP
> > 
> > Is this with CONFIG_SLAB or CONFIG_SLUB?
> > 
> > I don't see it in my test systems, but they're CONFIG_SLAB
> 
> OK, should have looked at the attachments:
> 
> ...
> CONFIG_SLAB=y
> # CONFIG_SLUB is not set
> # CONFIG_SLOB is not set
> ...
> 
> Since you also have this:
> 
> CONFIG_DEBUG_KERNEL=y
> 
> Can you tell me what source line corresponds to 
> 
> :sr_mod:sr_probe+0x17b/0x4a9

Ping on this, please.  I suspect it will tell us the faulting call is
kmalloc and that it's definitely a vm issue, but we need this data as a
first step.

James


