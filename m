From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Wed, 6 Aug 2014 23:39:10 -0700
Message-ID: <20140807063910.GB8151@infradead.org>
References: <20140806193233.GA11451@infradead.org>
 <Pine.LNX.4.44L0.1408061545030.1145-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44234 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbaHGGjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Aug 2014 02:39:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1408061545030.1145-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
> > I doubt either of them forces users to hack up flags for these cases.
> 
> Why was this change needed in the first place?  There's no explanation 
> in the patch itself.

Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?

> 
> > At least for windows I suspect it just never sends the LUN encoded
> > in the CDB and treats USB devices special instead of our insistance
> > on pretending they are SCSI-2.
> 
> We no longer pretend that USB mass-storage devices have any particular 
> SCSI level.  See commit 09b6b51b0b6c.

So the origina reported device must report SCSI-2 all by itself if he's
running a recent kernel, ok.

> > Maybe some of the USB people have on the wire traces or access to
> > device or windows documentation on this?
> 
> Most likely it varies with the version of Windows and the INQUIRY data
> returned by the device.
> 
> I can obtain hardware traces for the kinds of devices and computers 
> lying around here.  But what sort of combinations should I test?

I'd mostly be interested to see if it actualy encodes the LUN in the CDB
for any USB multi-LUN device.
