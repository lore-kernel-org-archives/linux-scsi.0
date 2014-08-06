From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Wed, 6 Aug 2014 16:02:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408061545030.1145-100000@iolanthe.rowland.org>
References: <20140806193233.GA11451@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49519 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752723AbaHFUCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2014 16:02:24 -0400
In-Reply-To: <20140806193233.GA11451@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Tiziano Bacocco <tiziano.bacocco@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Wed, 6 Aug 2014, Christoph Hellwig wrote:

> On Wed, Aug 06, 2014 at 03:29:47PM +0200, Douglas Gilbert wrote:
> > If not and since I'm told black lists and the like won't
> > work, my advice for the record is to use FreeBSD or Windows
> > for tools that need this capability.
> 
> I doubt either of them forces users to hack up flags for these cases.

Why was this change needed in the first place?  There's no explanation 
in the patch itself.

> At least for windows I suspect it just never sends the LUN encoded
> in the CDB and treats USB devices special instead of our insistance
> on pretending they are SCSI-2.

We no longer pretend that USB mass-storage devices have any particular 
SCSI level.  See commit 09b6b51b0b6c.

> Maybe some of the USB people have on the wire traces or access to
> device or windows documentation on this?

Most likely it varies with the version of Windows and the INQUIRY data
returned by the device.

I can obtain hardware traces for the kinds of devices and computers 
lying around here.  But what sort of combinations should I test?

Alan Stern

