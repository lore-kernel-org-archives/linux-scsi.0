From: Jens Axboe <axboe@suse.de>
Subject: Re: CDC_RAM for lk 2.4, PATCH proposed
Date: Fri, 21 May 2004 08:53:15 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040521065312.GK1952@suse.de>
References: <20040520080622.GF1952@suse.de> <1085090500.3822.20.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:43464 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265403AbUEUGxi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 May 2004 02:53:38 -0400
Content-Disposition: inline
In-Reply-To: <1085090500.3822.20.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, John McKell <McKellj@iomega.com>

On Thu, May 20 2004, Pat LaVarre wrote:
> diff confirms for me the patch inline of this post matches what John
> McKell posted, except for the trivial difference of folder names & dates
> and the substantive difference that I did comment out the per-open
> printk:
> 
> - + printk("cdrom: %s opening for WRITE\n", current->comm);
> + + /* printk("cdrom: %s opening for WRITE\n", current->comm); */

That's fine, I killed that in 2.6 as well.

> > > I believe 2.4.18 patch actually makes `mount -w` work there by way of
> > > "see all DVD/CD drives as DVD-RAM/ DVD-ROM compatible".
> > 
> > But that's not what the patch does at all. The patch simply says "If we
> > succeeded in retriving the mode capability page, ignore what it says and
> > flag the drive as dvd-rom/ram capable" which is clearly bogus.
> 
> To newbie me, this is not clearly bogus, sorry.
> 
> 1)
> 
> I see my 2.4.18 patch makes `mount -w` work, by way of breaking `cat
> /proc/sys/dev/cdrom/info`.
> 
> mount matters more to me than proc.
> 
> Besides, the breakage is small.  I'm not falsely claiming that a DVD-RAM
> disc is present.  I'm only falsely claiming that a DVD-RAM disc could be
> present.  Software that branches visibly on which kind of disc might
> someday be present looks very nearly bogus to me.

Sorry, I still think this is completely bogus. No point in debating it,
there's no way that hack will go into the 2.4 kernels.

> 2)
> 
> I see my 2.4.18 patch is extremely short and simple.
> 
> Simplicity in the patch matters more to me the further I step back from
> the latest available at kernel.org.

Your 2.4.18 patch is a hack.

> diff -Nurp linux-2.4.27-pre3/include/linux/cdrom.h linux-2.4.27-pre3-pel/include/linux/cdrom.h

[snip]

Patch looks fine to me, I'll send it to Marcelo for inclusion. Thanks!

-- 
Jens Axboe

