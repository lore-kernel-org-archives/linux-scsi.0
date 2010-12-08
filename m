From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH repost 3] [SCSI] Retrieve the Caching mode page
Date: Wed, 08 Dec 2010 09:43:32 -0600
Message-ID: <1291823012.24312.52.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1012081010470.1885-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981Ab0LHPnl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Dec 2010 10:43:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.1012081010470.1885-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Luben Tuikov <ltuikov@yahoo.com>, Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, 2010-12-08 at 10:16 -0500, Alan Stern wrote:
> On Tue, 7 Dec 2010, James Bottomley wrote:
> 
> > Well, not other than I've already said:  I think it looks OK, so I
> > marked it for my merge window queue.  I'd still rather like USB people
> > to confirm that the original reason why this was done (to prevent device
> > crashes on the mode sense) is no longer an issue
> 
> The original reason for adding the skip_ms_page_8 flag still applies.  
> To assume it is no longer an issue would not be safe -- there's no 
> reason to believe that the buggy devices it was meant for have all been 
> retired.
> 
> >  ... but it's only USB
> > stuff, so suppose I'm OK with finding out in the field.
> 
> With USB there's often no other choice.

So the translation is that there's a possibility it will crash USB
devices but the only way to find out is to release it and see.

My problem is that it only takes one bug report from one failing device
(which I'm sure some kind soul will dig out of the attic or wherever
they threw it) for this to be a regression and then I get to revert the
patch ... unless we have a working backup plan?

I think it's easy to put in and easy to revert ... we'll pick up a bit
of flack if the failing device doesn't appear for some time, but I'm OK
with risking that.

James


