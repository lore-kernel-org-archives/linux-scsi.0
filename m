From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] dm mpath: add feature flag to control call to
 blk_abort_queue
Date: Wed, 17 Nov 2010 23:20:32 -0800
Message-ID: <20101118072032.GA13390@linux.vnet.ibm.com>
References: <20101117215541.GA7785@redhat.com>
 <1290055222-12320-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:54142 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890Ab0KRHUi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 02:20:38 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id oAI73jYE023404
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 02:03:45 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id oAI7Kbfs2273312
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 02:20:37 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id oAI7KalE027457
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 02:20:36 -0500
Content-Disposition: inline
In-Reply-To: <1290055222-12320-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>

Mike S,

Thanks for doing the refresh / update of the patch.
I just did a quick test and did not see any issues but did have a couple
of questions.

Two questions:

1.) Should we bump the multipath targets version for this change?

2.) A general question on the length of the feature name
"abort_queue_on_failure" while the descriptive name is nice I noticed if
I have two features that the multipath output line starts wrapping. I
guess we could make the feature name shorter, but eventually if we added
more features the line would eventually wrap so a shorted name will just
stop wrapping now.

(I had a old experimental patch where I was trying to use the feature
flags to control the selection of fast fail flags to use and if full
recovery was done on the IO. The output was kinda messy, but that is to
be expected with this type of text interface vs a attribute based
alternative.)

Thanks,

-andmike
--
Michael Anderson
andmike@linux.vnet.ibm.com
