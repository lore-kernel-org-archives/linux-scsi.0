From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: lots and lots of disks again
Date: Mon, 16 Feb 2004 23:57:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040216225704.GA3420@pclin040.win.tue.nl>
References: <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk> <20040212161800.GU1780@tpkurt.garloff.de> <1076604183.2576.89.camel@mulgrave> <20040216124047.GG4011@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhost.tue.nl ([131.155.2.7]:520 "EHLO mailhost.tue.nl")
	by vger.kernel.org with ESMTP id S265989AbUBPW5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Feb 2004 17:57:11 -0500
Content-Disposition: inline
In-Reply-To: <20040216124047.GG4011@tpkurt.garloff.de>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, viro@parcelfarce.linux.theplanet.co.uk, Andrew Morton <akpm@osdl.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, pbadari@us.ibm.com, willy@debian.org

> On Thu, Feb 12, 2004 at 11:43:03AM -0500, James Bottomley wrote:
> > Well, I've had my ear bent about gendisk aliasing not being feasible, so
> > to use the new major scheme, we'd have to have something like a boot
> > time switch in the kernel and only register either the old majors or the
> > new major.

I am not quite sure what you mean.
In my opinion we must continue supporting the old 16-bit space
for a long time to come. But can of course do what we want in
the new space.

It is not either or, but both.
Old devices must not change number.

On Mon, Feb 16, 2004 at 01:40:47PM +0100, Kurt Garloff wrote:

> This could be done. So we register one new major, with the 6bit
> partitions, allowing for 1<<14 disks with 1<<6 partitions each with
> one major.
> 
>  From a distributor's perspective, I currently see demand to have many
> (>1000) SCSI disks supported (*), but no serious demand for > 16 partitions,
> so we would not have trouble to wait with this until 2.7/2.8.

True. As fdisk maintainer I see a few complaints a year about the
upper bound 64. (But I like having much more space than is needed today.)

But let me stress again that "one major" hardly has any meaning.
You register a structureless interval of device numbers.

Andries
