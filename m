From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Re: BUG in kernel: Wrong Handling of USB =?UTF-8?Q?HDD=E2=80=99s?=
 in scsiglue(slave_configure) and scsi/sd(sd_read_cache_type)
Date: Mon, 3 Oct 2011 15:53:45 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1110031548310.1882-100000@iolanthe.rowland.org>
References: <1317670355.3041.53.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1317670355.3041.53.camel@dabdike.int.hansenpartnership.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>, Amit Sahrawat <amit.sahrawat83@gmail.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 3 Oct 2011, James Bottomley wrote:

> On Mon, 2011-10-03 at 14:10 -0400, Alan Stern wrote:
> > > No. You need to also take into account the RBC
> > > device parameters mode page if present. See above.
> > 
> > All right, suppose neither page is present.  Does it then make sense to 
> > assume by default that write caching is enabled?
> 
> You're the USB expert ... if we do that, we'll start sending
> SYNCHRONIZE_CACHE commands down to a whole slew of devices we didn't
> before ... is that going to cause problems with any USB SATLs?

Hmmm...  Actually, I doubt it would bother any SATLs, but it might well
bother other sorts of USB translation layers.  No way to tell without
trying it, and I don't really want to deal with the fallout.

Maybe a better question to be asking is this: What happens when one of 
these drives (the ones that report their caching capabilities 
incorrectly) is plugged into a Windows system?

Alan Stern

