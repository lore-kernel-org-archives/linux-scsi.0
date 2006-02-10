From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Fri, 10 Feb 2006 08:30:46 -0700
Message-ID: <20060210153046.GC12822@parisc-linux.org>
References: <20060210103634.GB27401@infradead.org> <Pine.LNX.4.44L0.0602101023390.5093-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:1417 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S932134AbWBJPar
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 10:30:47 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0602101023390.5093-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Feb 10, 2006 at 10:27:21AM -0500, Alan Stern wrote:
> On Fri, 10 Feb 2006, Christoph Hellwig wrote:
> > Do we need per-device blist flags at all?  I suspect just having them in
> > the target should be enough.
> 
> Some of the blist flags clearly are per-device: BLIST_KEY, BLIST_ISROM,
> BLIST_NOSTARTONADD, BLIST_MS_SKIP_PAGE_08, BLIST_MS_SKIP_PAGE_3F,
> BLIST_USE_10_BYTE_MS, BLIST_MS_192_BYTES_FOR_3F, BLIST_NOT_LOCKABLE,
> BLIST_NO_ULD_ATTACH, BLIST_RETRY_HWERROR.  There are a few others I'm not
> certain about.

Why are these clearly per LUN?  I agree some of them are debatable,
but most of them indicate a general lack-of-scsi-spec compliance on the
part of the manufacturer and hence apply to the piece of hardware (==
scsi target) rather than just one of the LUNs in it.
