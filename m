From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm mpath: add feature flag to control call to
 blk_abort_queue
Date: Thu, 18 Nov 2010 10:48:08 -0500
Message-ID: <20101118154807.GA15381@redhat.com>
References: <20101117215541.GA7785@redhat.com>
 <1290055222-12320-1-git-send-email-snitzer@redhat.com>
 <20101118072032.GA13390@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754115Ab0KRPsY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 10:48:24 -0500
Content-Disposition: inline
In-Reply-To: <20101118072032.GA13390@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

On Thu, Nov 18 2010 at  2:20am -0500,
Mike Anderson <andmike@linux.vnet.ibm.com> wrote:

> Mike S,
> 
> Thanks for doing the refresh / update of the patch.
> I just did a quick test and did not see any issues but did have a couple
> of questions.
> 
> Two questions:
> 
> 1.) Should we bump the multipath targets version for this change?

Yes, not doing so was an oversight.  I'll bump the version and post v3.

> 2.) A general question on the length of the feature name
> "abort_queue_on_failure" while the descriptive name is nice I noticed if
> I have two features that the multipath output line starts wrapping. I
> guess we could make the feature name shorter, but eventually if we added
> more features the line would eventually wrap so a shorted name will just
> stop wrapping now.

I'm open to other suggestions for the feature name.

I agree that we don't want feature names to get too long.  But they do
need to be descriptive.  So we need to have some balance.  I could've
used "abort_q_on_failure" but I went for "queue" to maintain symmetry
with "queue_if_no_path".  Similarly, abbreviating "failure" to "fail"
seemed like it didn't buy much (less clear?). *shrug* Maybe
"abort_queue_on_fail" offers a better balance?

As for the wrapping, I don't think there is anything we can do to avoid
it (given the current interface).

Thanks,
Mike
