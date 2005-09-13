From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Tue, 13 Sep 2005 13:00:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509131254250.4481-100000@iolanthe.rowland.org>
References: <1126291223.4799.35.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56548 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S964889AbVIMRAC
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 13:00:02 -0400
In-Reply-To: <1126291223.4799.35.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 9 Sep 2005, James Bottomley wrote:

> On Thu, 2005-09-08 at 16:49 -0400, Alan Stern wrote:
> > This hasn't been tested very thoroughly, so please look through it 
> > carefully.
> 
> Actually, just one problem and one cosmetic fix:
> 
> 1) We need to dequeue for the loop and kill case (it seems easiest
> simply to dequeue in the scsi_kill_request() routine)
> 2) There's no real need to drop the queue lock.  __scsi_done() is lock
> agnostic, so since there's no requirement, let's just leave it in to
> avoid any locking issues.

Have you applied this to any publicly-accessible tree yet?  I looked at 
the git browsers on parisc-linux.org and kernel.org, but the patch doesn't 
seem to be there yet.

For that matter, what about the other patches you agreed to take (as543 - 
as546)?  They aren't in the git repositories either.  It would be good if 
all these things could be ready in time for the next -mm release.

Alan Stern

