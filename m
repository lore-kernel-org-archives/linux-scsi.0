From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 7/8] SCSI: add a field to scsi_device to count open file
 references
Date: Wed, 5 Mar 2008 16:52:44 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0803051651090.4318-100000@iolanthe.rowland.org>
References: <1204752618.3047.77.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40020 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753129AbYCEVwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 16:52:45 -0500
In-Reply-To: <1204752618.3047.77.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 5 Mar 2008, James Bottomley wrote:

> > In fact, the only other important reason for not turning it on by
> > default (or always!) is because the USB spec says not to.  By adding
> > this check for mounted filesystems, we are trying to adhere as closely
> > as possible to the spec -- but only in cases where we don't care since
> > it doesn't matter!
> > 
> > Whether to enable USB-PERSIST for mounted devices is a policy decision.  
> > Whether that policy should be set by the kernel or by userspace is
> > outside my jursidiction.  If you think this approach is wrong-headed
> > and you can convince Linus to go along, I'll be willing to drop the
> > last three patches in this series.
> 
> So make it default to one now and also put the processes in train to
> update hal and udev.  That way everything should work immediately and we
> come back to spec compliance later.

Under the circumstances that sounds like a reasonable course of action.

Does anybody have a serious objection?

Alan Stern

