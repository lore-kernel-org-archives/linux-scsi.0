From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi_mid_low_api.txt for 2.5.46-bk3
Date: Fri, 8 Nov 2002 02:46:23 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108024623.A19182@infradead.org>
References: <3DCB0E51.5070407@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DCB0E51.5070407@torque.net>; from dougg@torque.net on Fri, Nov 08, 2002 at 12:07:29PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 08, 2002 at 12:07:29PM +1100, Douglas Gilbert wrote:
> This patch against 2.5.46-bk3 is work in progress
> (since the interface is in flux). It dusts of some
> cobwebs, removes politically incorrect typedefs and

I'd suggest to leave them in where the struct names are raraly used and even
worse (e.g. struct SHT), I'm probably going to a do a big cleansweap to
give them saner struct names soon, and the fewer users they acquired until
then the better..

> describes slave_attach() and slave_detach(). It
> removes the revoke() description (per hch? changes).

Patrick did it.

> Is a section describing mid level functions provided
> for LLDDs (e.g. scsi_adjust_queue_depth() )
> warranted?

LLDD = Low Level Driver Developer?

It looks like a good idea to me, but I wonder whether that should be
a separate Document.  BTW, what about movinf this and the other docs
(e.g. README.*) in drivers/scsi/ to Documentation/scsi/ ?

Another things that's worth mentioning is that ->detect and ->release are
option now if you don't write a scsi_module.c-style driver.

And thanks a lot for caring for the scsi documentation, I usually try to update
it for my changes, but you do a much better job..
