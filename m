From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Wed, 14 Sep 2005 09:59:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509140947350.5064-100000@iolanthe.rowland.org>
References: <1126647241.4809.65.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:27064 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965184AbVINN7v
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 09:59:51 -0400
In-Reply-To: <1126647241.4809.65.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 13 Sep 2005, James Bottomley wrote:

> > Have you applied this to any publicly-accessible tree yet?  I looked at 
> > the git browsers on parisc-linux.org and kernel.org, but the patch doesn't 
> > seem to be there yet.
> 
> Yes, they should both be in 2.6.14-rc1

And indeed they are.

> > For that matter, what about the other patches you agreed to take (as543 - 
> > as546)?  They aren't in the git repositories either.  It would be good if 
> > all these things could be ready in time for the next -mm release.
> 
> That I think was these [from the latest GIT PATCH email]:
> 
> > Alan Stern:
> >   o Fix module removal/device add race
> >   o fix callers of scsi_remove_device() who already hold the scan
> > muted
> >   o add missing scan mutex to scsi_scan_target()

Yes, I see those in 2.6.14-rc1 as well.  However there's still one patch 
missing (as545):

http://marc.theaimsgroup.com/?l=linux-scsi&m=112238804301664&w=2

That one fixes a real problem; it shows up whenever you remove a USB 
storage device.


An implicit point of my previous message was that I don't have a good way
to know when you have accepted one of my patch submissions.  Is there one
particular git tree I should look at, where an accepted patch will first
show up?  Or could you arrange to borrow Greg KH's script that sends out a
form email message whenever he applies a new patch to one of his main
development trees?

Alan Stern

