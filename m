From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/7] Fix various bugs in the target code
Date: Wed, 12 Aug 2009 14:31:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908121421220.23954-100000@iolanthe.rowland.org>
References: <1249919600.4089.111.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56688 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751880AbZHLSb6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2009 14:31:58 -0400
In-Reply-To: <1249919600.4089.111.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 10 Aug 2009, James Bottomley wrote:

> > 	If we have to wait for an old target to disappear, instead of
> > 	calling flush_scheduled_work() the patch calls
> > 	schedule_timeout_uninterruptible(1).  After all, whatever is
> > 	pinning the old target might not have anything to do with a
> > 	workqueue.  Besides, flush_scheduled_work() is prone to
> > 	deadlocks and should never be used by drivers.
> 
> I don't really buy this; it's not (yet) a documented restriction of
> flush_scheduled_work() and we have a few drivers using it.  It only
> deadlocks if you call it from a running workqueue.

Since you are so opposed to this patch, I will drop it from the series.
You didn't comment on any of the first three patches in the series; 
does that mean they are acceptable as is?

And what about the following patches?  I'll redo them based on omitting 
4/7; are there any parts of them you don't like?

Alan Stern

