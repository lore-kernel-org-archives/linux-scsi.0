From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [BUG 2.6.26-rc1] scsi (or sysfs or vm?) oops in sr_probe()
Date: Sun, 4 May 2008 09:38:15 -0600
Message-ID: <20080504153814.GC14976@parisc-linux.org>
References: <481D9C69.8080902@garzik.org> <1209914732.16283.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54030 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbYEDPiQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 11:38:16 -0400
Content-Disposition: inline
In-Reply-To: <1209914732.16283.27.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>

On Sun, May 04, 2008 at 10:25:31AM -0500, James Bottomley wrote:
> On Sun, 2008-05-04 at 07:22 -0400, Jeff Garzik wrote:
> > See attached files for additional config detail.
> > 
> > Platform summary:  AMD64 2x2 (== 4 cores), Fedora 8/x86-64
> > 
> > Driver 'sr' needs updating - please use bus_type methods
> > BUG: unable to handle kernel NULL pointer dereference at 00000000000005d8
> > IP: [<ffffffff8025e10c>] get_page_from_freelist+0x43/0x573
> > PGD 7e90f067 PUD 7edbc067 PMD 0
> > Oops: 0000 [1] SMP
> 
> Is this with CONFIG_SLAB or CONFIG_SLUB?
> 
> I don't see it in my test systems, but they're CONFIG_SLAB

He posted his .config and it's SLAB.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
