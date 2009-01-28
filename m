From: Dirk Hohndel <hohndel@infradead.org>
Subject: Re: strange USB storage failure with 2.6.29-rc2
Date: Wed, 28 Jan 2009 13:22:28 -0800
Message-ID: <20090128132228.3f1e2f8a@infradead.org>
References: <20090127122641.1564fc46@infradead.org>
	<Pine.LNX.4.44L0.0901271548370.2286-100000@iolanthe.rowland.org>
	<20090127200607.369a1693@infradead.org>
	<20090128141035.3a26ea60.zaitcev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51602 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZA1VWo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 16:22:44 -0500
In-Reply-To: <20090128141035.3a26ea60.zaitcev@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, zaitcev@redhat.com

On Wed, 28 Jan 2009 14:10:35 -0700
Pete Zaitcev <zaitcev@redhat.com> wrote:

> On Tue, 27 Jan 2009 20:06:07 -0800, Dirk Hohndel <hohndel@infradead.org> wrote:
> 
> > On a 64bit 2.6.29-rc2 system (and a few earlier kernels that I have
> > tried) I can no longer use USB sticks.
> 
> So how do you know that you "no longer" can use USB sticks if you
> did not find a kernel where it worked? It's either one or the other.

Very good point.

I know that I had it working when I installed F10. It doesn't work
right now, but there have been lots of updates to F10 since.
Not sure how to get back to the old state except for reinstalling F10
from the original media...

> > > >From the middle of the log (after the partition table has been read):
> > > 
> > > > [   32.056855] usb-storage: queuecommand called
> > > > [   32.056886] usb-storage: *** thread awakened.
> > > > [   32.056888] usb-storage: Command START_STOP (6 bytes)
> 
> Middle huh. I _really_ wish people stopped editing their logs. How
> am I supposed to determine if this was sent immediately after open
> (e.g. your HAL is screwing with you), or it happened after a time
> of inactivity?

I initially sent out the complete log - Alan cut it down. Here's the
link to the relevant email in this thread:

http://kerneltrap.org/mailarchive/linux-usb/2009/1/27/4830624

> In the latter case you might try to comment out
> sdev->allow_restart = 1  from scsiglue.c.
> It was added there for a specific reason: Seagate FreeAgent.
> We can easily make it specific for Seagate, *IF* commenting it helps.
> 
> In the former case, well, complain to distro.

It's Fedora 10.

/D

-- 
Dirk Hohndel
Intel Open Source Technology Center
