From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Bug 80711] [PATCH]SG_FLAG_LUN_INHIBIT is no longer implemented
 and there's not way to prevent the kernel from using the 2nd cdb byte for
 the LUN
Date: Tue, 19 Aug 2014 10:56:25 -0700
Message-ID: <20140819175625.GB4617@infradead.org>
References: <20140807063910.GB8151@infradead.org>
 <Pine.LNX.4.44L0.1408071149100.912-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39615 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaHSR4k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Aug 2014 13:56:40 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1408071149100.912-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Tiziano Bacocco <tiziano.bacocco@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, bugzilla-daemon@bugzilla.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, Aug 07, 2014 at 11:58:37AM -0400, Alan Stern wrote:
> > On Wed, Aug 06, 2014 at 04:02:22PM -0400, Alan Stern wrote:
> > > > I doubt either of them forces users to hack up flags for these cases.
> > > 
> > > Why was this change needed in the first place?  There's no explanation 
> > > in the patch itself.
> > 
> > Which chance?  The one to not support SG_FLAG_LUN_INHIBIT?
> 
> No, the patch that started this Bugzilla entry.  Tiziano says it is 
> needed in order to send vendor-specific commands that use the LUN bits 
> in CDB[1].

Yes, I'd really like to know the exact scenario.  What kind of command
is this and who sends it?

