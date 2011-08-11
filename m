From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] libcxgbi: Fix some build warnings missed during cleanup
 of a previous patch
Date: Thu, 11 Aug 2011 10:45:47 -0400
Message-ID: <20110811144547.GA23747@hmsreliant.think-freely.org>
References: <1313059644-25087-1-git-send-email-nhorman@tuxdriver.com>
 <1313071497.4166.0.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46575 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab1HKOp4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2011 10:45:56 -0400
Content-Disposition: inline
In-Reply-To: <1313071497.4166.0.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Divy Le Ray <divy@chelsio.com>, Steve Wise <swise@chelsio.com>, Karen Xie <kxie@chelsio.com>, Mike Christie <michaelc@cs.wisc.edu>

On Thu, Aug 11, 2011 at 02:04:56PM +0000, James Bottomley wrote:
> On Thu, 2011-08-11 at 06:47 -0400, Neil Horman wrote:
> > I recently submitted this:
> > http://marc.info/?l=linux-scsi&m=131228153521094&w=2
> > 
> > Patch to fix an oops in the cxgb3i iscsi driver.  I did what I thought was some
> > minor cleanup after testing and prior to submission.  Of course that bit me, and
> > and a result I introduced some build warnings that really don't need to be
> > there.  This patch corrects them.  Apologies for the noise
> 
> OK, so since the previous patch was a bug fix, can you resend the
> complete, clean bug fix with a stable tag.
> 
> Thanks,
> 
> James
> 
Absolutely, sorry for the noise
Neil

