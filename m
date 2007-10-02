From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [git patch] SCSI aic94xx fix
Date: Tue, 02 Oct 2007 13:47:42 -0500
Message-ID: <1191350862.3530.114.camel@localhost.localdomain>
References: <20071002172151.GA28579@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:49991 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514AbXJBSrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 14:47:45 -0400
In-Reply-To: <20071002172151.GA28579@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Tue, 2007-10-02 at 13:21 -0400, Jeff Garzik wrote:
> The SCSI maintainer wants to wait until 2.6.25 for this obvious data

That's 2.6.24 ... and that's not what I said.  I said I wanted to take
it via scsi-misc into 2.6.24 and then take it via the stable tree for
2.6.23.x

> corruption fix.
> 
> I vehemently disagree.

Sure, I'll state my case:  This is a bug, but it has no affected users,
nor will it because the aic94xx doesn't work on non-x86 architectures by
reason of other longstanding bugs (and TODEVICE/FROMDEVICE only matters
to architecures which use dma_map_sg to program the IOMMU).  Given that
we're at -rc9 and counting every patch towards stabilisation, I see no
benefit to adding this to the tree because the benefit to users is zero
and the detriment from code churn at this stage is potentially non-zero.

My recommendation is still to follow what I propose: take it via
scsi-misc to 2.6.24-rc1 and then back to 2.5.23.x

James


