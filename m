From: Ingo Molnar <mingo@elte.hu>
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Thu, 19 Feb 2009 21:23:17 +0100
Message-ID: <20090219202317.GA784@elte.hu>
References: <20090218155817.GC23989@elte.hu> <Pine.LNX.4.44L0.0902191505050.7953-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:56738 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZBSUX2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Feb 2009 15:23:28 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0902191505050.7953-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 18 Feb 2009, Ingo Molnar wrote:
> 
> > 
> > * Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > I have no idea if this will make any difference for the 
> > > problem you're seeing, but it has been submitted and it's 
> > > worth trying out.  If the problem still occurs, I'll write a 
> > > diagnostic patch to add log messages giving the destiny of 
> > > each request in scsi_io_completion().
> > 
> > OK, i've undone the reverts and have applied your fix - it will 
> > take a few hours to see whether the hang still occurs.
> 
> Any definitive results yet?

Yes, as i wrote before, the bug is fixed.

> It turns out that the patch I posted earlier is not quite 
> correct; the "__scsi_release_buffers(cmd, 0);" line in 
> scsi_end_request() was added after the patch was first written 
> and then got lost during rebasing.

Yeah, rebasing is a really bad idea in general.

> If this really does fix your problem and nobody has any other 
> objections to it, I'll submit a revised version with the 
> missing line added back in.

Sure, no objections.

	Ingo
