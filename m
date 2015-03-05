From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [TOPIC] scsi-queue tree past and future
Date: Thu, 05 Mar 2015 06:48:08 -0800
Message-ID: <1425566888.2169.17.camel@HansenPartnership.com>
References: <20150305133118.GA16575@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60879 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751438AbbCEOsL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2015 09:48:11 -0500
In-Reply-To: <20150305133118.GA16575@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: lsf@lists.linux-foundation.org, lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org

On Thu, 2015-03-05 at 14:31 +0100, Christoph Hellwig wrote:
> For about 8 month I've merged almost every scsi commit through the
> scsi-queue staging tree, and it seems to have worked out well enough.
> 
> I've been too busy for the next cycle, so 4.1 will probably have to live
> without it.  I'd like to get feedback on how the tree worked for contributors
> and driver maintainers, and brainstorm how to move forward with it, preferably
> some form of real team maintainance that avoids single points of failure.

I'd like to thank Christoph for doing this, it's been an enormous help.

Here's what we'll do for 4.1: I need all the current Maintainers to
collect the patches and reviews in their area and send them to the list
as a series.  We'll be adhering to the guidelines Christoph laid down
for inclusion:

 - the patch needs at least two positive reviews (non-author signoff,
   reviewed-by or acked-by tags).   In practice this means it had at
   least one and I added another one.
   As an exception I also take trivial and important fixes if they
   only have a Tested-by: instead of a second review.
 - the patch has no negative review on the mailing list
 - the patch applies cleanly
 - the patch compiles (drivers for architectures I can't test excluded)
 - for core the core branch: the patch survives a full xfstests run

For the last requirement, the 0 day kernel test project will be checking
this.  That means negative reports from the 0 day project on a patch
will be grounds for removal.

I'll try to curate the patches in areas without maintainers (like the
core).  Remember, in all cases, you get an email from my automation
infrastructure when a patch is added (or removed) from any of the SCSI
trees, so if you haven't seen the email, the patch isn't in the tree.

You can also see the state of the git trees here:

http://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/

with the misc branch being for 4.1 and the fixes branch being for 4.0-rc

James


