From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Kernel 2.6.x hangs with Symbios Logic 53c1010 Ultra3 SCSI Ada pter
Date: Sat, 6 Nov 2004 12:03:58 +0000
Message-ID: <20041106120358.GC23305@infradead.org>
References: <D5169CBBC6369D4CBFFABD7905CC9D695D31@tehran.Fars-Robotics.local> <20041106035951.GC24690@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:19721 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261368AbUKFMEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Nov 2004 07:04:04 -0500
Content-Disposition: inline
In-Reply-To: <20041106035951.GC24690@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Richard Waltham <richard@fars-robotics.net>, SUPPORT <support@4bridgeworks.com>, Thomas Babut <thomas@babut.net>, linux-kernel@vger.kernel.org, Linux SCSI <linux-scsi@vger.kernel.org>, groudier@free.fr

On Sat, Nov 06, 2004 at 03:59:51AM +0000, Matthew Wilcox wrote:
> On Sat, Nov 06, 2004 at 12:02:32AM -0000, Richard Waltham wrote:
> > Good as a backup but the original PPR capability is defined in
> > scan_scsi.c. Shouldn't scan_scsi.c take note of the bus mode and enable
> > PPR capabilities accordingly? This would then cover this issue for all
> > relevant LLDDs wouldn't it?
> 
> scan_scsi.c doesn't know what mode the bus is in.  scan_scsi.c doesn't
> even know whether the bus is SPI, FC, iSCSI, SAS or SATA.

And PPR only makes sense for SPI anyway.  An good argument why this
should move to the SPI transport class, which does know about SE vs HVD
vs LVD.

