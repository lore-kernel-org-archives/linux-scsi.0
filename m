From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 12:36:41 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309221231500.636-100000@ida.rowland.org>
References: <20030922085803.A722@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:9732 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263209AbTIVQgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 12:36:42 -0400
In-Reply-To: <20030922085803.A722@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 22 Sep 2003, Patrick Mansfield wrote:

> On Mon, Sep 22, 2003 at 11:50:47AM -0400, Alan Stern wrote:
> 
> > I don't care which version of the patch gets accepted, so long as
> > _something_ is done.  Patrick, what do you think?
> 
> I would rather we can modify the flags for any broken device and override
> a host's setting for known functioning devices. But let's get some patch
> applied.

Yes.  But be sure to allow host drivers to adjust the flag within
slave_config(); slave_alloc() may be too early.  (Although since sd.c is 
the only driver that uses the flag, I guess it doesn't matter.)

> If there is a problem (per Linus' post) in the USB transport this isn't a
> real fix.

The problems that Linus and many other people are seeing aren't in the USB 
transport; they are bugs in the device firmware.  These bugs manifest as 
errors reported by the transport drivers.

Alan Stern

