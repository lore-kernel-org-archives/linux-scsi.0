From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 21:42:33 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210214232.GH21151@parcelfarce.linux.theplanet.co.uk>
References: <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210155203.A5238@infradead.org> <20040210160803.GL4010@tpkurt.garloff.de> <20040210211002.A1534@pclin040.win.tue.nl> <20040210205833.GT4010@tpkurt.garloff.de> <20040210212113.GG21151@parcelfarce.linux.theplanet.co.uk> <20040210213438.GV4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:41626 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261774AbUBJVme
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:42:34 -0500
Content-Disposition: inline
In-Reply-To: <20040210213438.GV4010@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Andries Brouwer <aebr@win.tue.nl>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Feb 10, 2004 at 10:34:38PM +0100, Kurt Garloff wrote:
> > Bit shuffling where?  Since partitioning does *not* reach the driver (nor
> > should it), I really wonder where exactly do you expect that turd to land.
> 
> We always needed to tell the gendisk code what part of the minor refers
> to disks and which one to partitions. The knowledge is there, like it or
> not.

Hell, no.  We tell the upper layers that gendisk covers device numbers from
dev to dev + N - 1.  That has nothing to do with bitmasks, majors or minors.

And _that_ is generic enough to be handled by upper layers.  Driver doesn't
care about any device numbers past that point.  At all.  It gets pointers
to gendisk and that's it.
 
> > > I don't see what's crappy with the suggestion. Tell us!
> > 
> > Putting partitioning crap back into driver.
> 
> Oh well, are you happier if we declare the two bits reserved instead
> of having the hope of using them to extend the number of partitions per 
> disk to 64 per disk some day?

No, I'm not.
