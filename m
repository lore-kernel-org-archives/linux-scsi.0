From: ard <ard@kwaak.net>
Subject: Re: [PATCH 0/3] scsi: fcoe: memleak fixes
Date: Mon, 6 Aug 2018 16:24:14 +0200
Message-ID: <20180806142414.GB23827@kwaak.net>
References: <20180731134603.20089-1-jthumshirn@suse.de>
 <20180806092503.6ed56kukj2i236qt@linux-x5ow.site>
 <20180806132234.GA23827@kwaak.net>
 <20180806132725.ihbi5rxvkuuppajr@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180806132725.ihbi5rxvkuuppajr@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Johannes,

On Mon, Aug 06, 2018 at 03:27:25PM +0200, Johannes Thumshirn wrote:
> On Mon, Aug 06, 2018 at 03:22:34PM +0200, ard wrote:
> > Ahh, yeah, sorry.
> > I did test them.
> > I can't say I see a regression.
> > I also can't say I see progress, although it feels like there is
> > a tad less leaking.
> > For that I need to do some statistics.
> > 
> > But for now I ack that it does not regress further.
> 
> From what I've seen in your kmemleak reports, it wasn't only
> libfc/fcoe that was leaking memory.
> 
> So kmemleak reports are welcome (especially if they confirm libfc/fcoe
> is clean now ;-)).
I've updated the ticket:
https://github.com/hardkernel/linux/issues/360#issuecomment-410721997
dmesg (with full debugging):
https://github.com/hardkernel/linux/files/2262858/dmesg-2018-08-06.txt
and kmemleak:
https://github.com/hardkernel/linux/files/2262861/kmemleak-2018-08-06.txt

I'll have to take a good look at the what and why.
I'm gonna git clean -x -d and rebuild the kernel, because this is
weird.

This is the tree I build:
https://github.com/ardje/linux/tree/gb-4.14-fcoe-patch
So vanilla linux-4.14 with the patch set:
https://github.com/ardje/linux/commit/747bf04057a99be5b01f768654cfd61bc9f4fc6c
Meh, I should try to use git for patching.

I will spam some printk's later on, just to check which flows are
followed (if the git clean doesn't reveal some problem, although
I can't imagine).

Regards,
Ard

-- 
.signature not found
