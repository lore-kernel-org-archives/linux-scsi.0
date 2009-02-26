From: Robert Love <robert.w.love@intel.com>
Subject: Re: [PATCH 00/17] Open-FCoE Updates
Date: Thu, 26 Feb 2009 10:29:34 -0800
Message-ID: <1235672974.4219.8.camel@fritz>
References: <20090206185548.26188.51580.stgit@fritz>
	 <49A6033D.8040600@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8541 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbZBZS3j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2009 13:29:39 -0500
In-Reply-To: <49A6033D.8040600@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@hansenpartnership.com" <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, 2009-02-25 at 18:49 -0800, Mike Christie wrote:
> Robert Love wrote:
> > The following series implements bug fixes, adds a module param for runtime debug logging and cleans up some coding style issues. The top patch is a patch that was posted to linux-scsi on 01/04, but doesn't seem to have made it in yet.
> > 
> > This patch set is based on Linus' tree + the Open-FCoE patches submitted to linux-scsi on 01/21.
> > 
> 
> Were these patches and that other patchset for 2.6.29-rc? This one had 
> some non bug fixes. I was not sure if you can do that in a rc. I was not 
> sure if because it is a new driver you get a exception since there can 
> be no regressions.
> 
They were intended for the RC phase, should I have been more explicit?
I'm not sure what the policy is exactly, I've heard that the RC phase is
only for regressions, but I'm not sure how that applies to new drivers.
We have nothing to regress from and I'd prefer getting these fixes in so
that FCoE in 2.6.29 is as stable as can be.

I agree that the logging stuff is a feature and not a fix, so it should
not go in the RC. Also, there is one locking fix that introduced a
defect that is later fixed in another patch. I'll re-do the patch set-
pull out the locking changes, and merge the two locking patches. Can
these fixes still make 2.6.29?

I have a handful of fixes that I was going to send out on Friday, but
I'll include them in the series as the last few patches. I'll call them
out in the cover mail too. 

> The first bunch of patches from 1/21 look ok.
> 
> The patches below looked ok too. I was not sure about the underrun 
> handling in this one though:
> 
> > Vasu Dev (1):
> >       libfc: fixed a read IO data integrity issue when a IO data frame lost
> > 
> 
> I always mess underrun handling up.
> 
> Other patches looked ok.
> 
> Reviewed-by: Mike Christie <micaelc@cs.wisc.edu>

Thanks for the review.

