From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 11:50:47 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309221147340.636-100000@ida.rowland.org>
References: <20030922161104.A24155@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:5636 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S263184AbTIVPut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 11:50:49 -0400
In-Reply-To: <20030922161104.A24155@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 22 Sep 2003, Christoph Hellwig wrote:

> On Mon, Sep 22, 2003 at 03:31:24PM +0100, Christoph Hellwig wrote:
> > Patch looks mostly fine to me, but please all flags should be unsigned instead
> > of signed and scsi_devinfo.h needs some inclusion guards.
> 
> Actually I think it could be made much simpler by killing the per-template
> bflags and just setting the scsi_device flags from slave_alloc or
> slave_configure.  Could you cook up a patch like that?

Interestingly, my original patch was a lot like you describe.  It can be 
found in

http://marc.theaimsgroup.com/?l=linux-scsi&m=106340167723122&w=2

Patrick Mansfield later beefed it up to the version you were looking at.

I don't care which version of the patch gets accepted, so long as
_something_ is done.  Patrick, what do you think?

Alan Stern


