From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: lots and lots of disks again
Date: Tue, 17 Feb 2004 15:49:59 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040217144959.GA4282@pclin040.win.tue.nl>
References: <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de> <20040216225704.GA3420@pclin040.win.tue.nl> <1076979373.1758.688.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:2318 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S266216AbUBQOuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Feb 2004 09:50:08 -0500
Content-Disposition: inline
In-Reply-To: <1076979373.1758.688.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries Brouwer <aebr@win.tue.nl>, Kurt Garloff <garloff@suse.de>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

On Mon, Feb 16, 2004 at 07:56:10PM -0500, James Bottomley wrote:
> On Mon, 2004-02-16 at 17:57, Andries Brouwer wrote:
> > I am not quite sure what you mean.
> > In my opinion we must continue supporting the old 16-bit space
> > for a long time to come. But can of course do what we want in
> > the new space.
> 
> The problem is that we cannot have /dev/sda1 at both (8,1) and (1049, 1)
> or whatever new major is chosen.

True. In my opinion it must stay at (8,1).

> We also need to flip the switch entirely one way or the other for
> increased partition numbers since a mixed scheme would be asking for an
> admin nightmare.

Why would that be?

Suppose /dev/sdAA is (1049,0) and has 256 partitions.
And /dev/sda is (8,0) and has 16 partitions.
Where is the nightmare?

> > It is not either or, but both.
> > Old devices must not change number.
> 
> I don't understand this.  The user does not know devices by number but
> by device node name (which is chosen by the OS vendor who populated
> /dev/ now, or by udev in future).  I agree the node name should not
> change, but don't see any reason why the major/minor might not.

That is (i) because people do not change device nodes when they boot
a new kernel, and (ii) because the knowledge is built-in into a
nontrivial number of programs.

Andries

