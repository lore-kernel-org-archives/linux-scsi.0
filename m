From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [Lsf] [TOPIC] scsi-queue tree past and future
Date: Fri, 06 Mar 2015 20:22:32 -0800
Message-ID: <1425702152.19505.106.camel@stgolabs.net>
References: <20150305133118.GA16575@lst.de>
	 <1425566888.2169.17.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:51708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762AbbCGEWk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Mar 2015 23:22:40 -0500
In-Reply-To: <1425566888.2169.17.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, lsf@lists.linux-foundation.org, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Thu, 2015-03-05 at 06:48 -0800, James Bottomley wrote:
> On Thu, 2015-03-05 at 14:31 +0100, Christoph Hellwig wrote:
> > For about 8 month I've merged almost every scsi commit through the
> > scsi-queue staging tree, and it seems to have worked out well enough.
> > 
> > I've been too busy for the next cycle, so 4.1 will probably have to live
> > without it.  I'd like to get feedback on how the tree worked for contributors
> > and driver maintainers, and brainstorm how to move forward with it, preferably
> > some form of real team maintainance that avoids single points of failure.
> 
> I'd like to thank Christoph for doing this, it's been an enormous help.
> 
> Here's what we'll do for 4.1: I need all the current Maintainers to
> collect the patches and reviews in their area and send them to the list
> as a series.  We'll be adhering to the guidelines Christoph laid down
> for inclusion:
> 
>  - the patch needs at least two positive reviews (non-author signoff,
>    reviewed-by or acked-by tags).   In practice this means it had at
>    least one and I added another one.
>    As an exception I also take trivial and important fixes if they
>    only have a Tested-by: instead of a second review.
>  - the patch has no negative review on the mailing list
>  - the patch applies cleanly
>  - the patch compiles (drivers for architectures I can't test excluded)
>  - for core the core branch: the patch survives a full xfstests run

This should be pretty standard in all subsystems, no?  And I know this
has been discussed many times, but I see no reason not to also consider
trinity -- which has a tendency of kicking you in the nuts when you
least expect it to. At least in MM we are trying to be a bit more
proactive about this, perhaps Sasha or Dave would disagree with me ;)
But in general it would also help other subsystems.

Thanks,
Davidlohr

