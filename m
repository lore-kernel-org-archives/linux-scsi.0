From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 17:37:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030922173732.A25639@infradead.org>
References: <20030922004943.E32009@one-eyed-alien.net> <Pine.LNX.4.44L0.0309221001090.1697-100000@ida.rowland.org> <20030922153123.A23388@infradead.org> <20030922161104.A24155@infradead.org> <20030922084930.A679@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:29200 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263225AbTIVQhz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 12:37:55 -0400
Content-Disposition: inline
In-Reply-To: <20030922084930.A679@beaverton.ibm.com>; from patmans@us.ibm.com on Mon, Sep 22, 2003 at 08:49:30AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Linus Torvalds <torvalds@osdl.org>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, Sep 22, 2003 at 08:49:30AM -0700, Patrick Mansfield wrote:
> On Mon, Sep 22, 2003 at 04:11:04PM +0100, Christoph Hellwig wrote:
> > On Mon, Sep 22, 2003 at 03:31:24PM +0100, Christoph Hellwig wrote:
> > > Patch looks mostly fine to me, but please all flags should be unsigned instead
> > > of signed and scsi_devinfo.h needs some inclusion guards.
> > 
> > Actually I think it could be made much simpler by killing the per-template
> > bflags and just setting the scsi_device flags from slave_alloc or
> > slave_configure.  Could you cook up a patch like that?
> 
> You mean add the flags to scsi_device rather than scsi_host?
> And allow setting the sdev->flags only in slave_alloc.

What I meant is not adding a blist flags member at all but rather
setting skip_ms_page_8 and skip_ms_page_3f from ->slave_alloc.

But I probably missed something obvious :)

