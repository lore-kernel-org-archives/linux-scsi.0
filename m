From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: SCSI BLIST_*, sdev_bflags, and scsi_device flags
Date: Fri, 10 Feb 2006 10:27:21 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602101023390.5093-100000@iolanthe.rowland.org>
References: <20060210103634.GB27401@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:14261 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932137AbWBJP10
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 10:27:26 -0500
In-Reply-To: <20060210103634.GB27401@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 10 Feb 2006, Christoph Hellwig wrote:

> > What about things like BLIST_REPORTLUN2 and BLIST_NOREPORTLUN?  They don't
> > mean anything for scsi_devices, only for scsi_targets.  Nevertheless they
> > are part of the same BLIST entries.  Again, I don't see any way around
> > that without affecting userspace.
> 
> Do we need per-device blist flags at all?  I suspect just having them in
> the target should be enough.

Some of the blist flags clearly are per-device: BLIST_KEY, BLIST_ISROM,
BLIST_NOSTARTONADD, BLIST_MS_SKIP_PAGE_08, BLIST_MS_SKIP_PAGE_3F,
BLIST_USE_10_BYTE_MS, BLIST_MS_192_BYTES_FOR_3F, BLIST_NOT_LOCKABLE,
BLIST_NO_ULD_ATTACH, BLIST_RETRY_HWERROR.  There are a few others I'm not
certain about.

Alan Stern

