From: viro@parcelfarce.linux.theplanet.co.uk
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 21:21:13 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210212113.GG21151@parcelfarce.linux.theplanet.co.uk>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210155203.A5238@infradead.org> <20040210160803.GL4010@tpkurt.garloff.de> <20040210211002.A1534@pclin040.win.tue.nl> <20040210205833.GT4010@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9877 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265921AbUBJVVR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 16:21:17 -0500
Content-Disposition: inline
In-Reply-To: <20040210205833.GT4010@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Andries Brouwer <aebr@win.tue.nl>, Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>

On Tue, Feb 10, 2004 at 09:58:33PM +0100, Kurt Garloff wrote:
> Hi Andries,
> 
> On Tue, Feb 10, 2004 at 09:10:02PM +0100, Andries Brouwer wrote:
> > + *       major     p2    disc2   disc  p1
> > + *   |............|..|..........|....|....| <- dev_t
> > + *    31        20    17       8 7  4 3  0
> [...]
> > 
> > It is true that the first step needed is some agreement on
> > how to assign device numbers to disks and their partitions.
> > 
> > The above suggestion is really ugly, however.

Uh-oh...  Rare event: I agree with aeb.
> 
> We maintain backwards compatibility.
> We need some bit shuffling and the rest is straightforward.

Bit shuffling where?  Since partitioning does *not* reach the driver (nor
should it), I really wonder where exactly do you expect that turd to land.

> I don't see what's crappy with the suggestion. Tell us!

Putting partitioning crap back into driver.
