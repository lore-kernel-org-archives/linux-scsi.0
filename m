From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] 2.6.2, Partition support for SCSI CDROM...
Date: Mon, 23 Feb 2004 22:11:30 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040224061130.GC503530@sgi.com>
References: <40396134.6030906@realitydiluted.com> <20040222190047.01f6f024.akpm@osdl.org> <40396E8F.4050307@realitydiluted.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtvcafw.sgi.com ([192.48.171.6]:44530 "EHLO zok.sgi.com")
	by vger.kernel.org with ESMTP id S262178AbUBXGMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Feb 2004 01:12:13 -0500
Content-Disposition: inline
In-Reply-To: <40396E8F.4050307@realitydiluted.com>
List-Id: linux-scsi@vger.kernel.org
To: "Steven J. Hill" <sjhill@realitydiluted.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Feb 22, 2004 at 10:07:59PM -0500, Steven J. Hill wrote:
> Andrew Morton wrote:
> >
> >>+config BLK_DEV_SR_PARTITIONS
> >>+config BLK_DEV_SR_PARTITIONS_PER_DEVICE
> >
> >
> >Do we actually need these config options?  Why not hardwire it to some
> >reasonable upper bound and be done with it?
> >
> I have no problem hardwiring the number of partitions, but the
> BLK_DEV_SR_PARTITIONS should still be an option to allow the
> user to decided if they want partitioning support for their
> SCSI CDROMs. Or are you suggesting that from now on partitions
> will be supported by default?

A couple of comments on this.

First, I've seen CDs in which the capacity reported by the CD is
actually slightly greater than the number of burned sectors.  In
that case, you'll get errors during the partition scanning.  You
can just ignore the errors, however, so it's no big deal.

Also, the default should probably be 16 partitions, since that
is what's supported on SGI CDs.  Most SGI CDs are in ISO format,
but Irix installation CDs do have an SGI partition table.

jeremy
