From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Patch status?
Date: Fri, 27 Oct 2006 17:01:50 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610271700580.8840-100000@iolanthe.rowland.org>
References: <1161981924.3744.62.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:55055 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1752451AbWJ0VCI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Oct 2006 17:02:08 -0400
In-Reply-To: <1161981924.3744.62.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 27 Oct 2006, James Bottomley wrote:

> On Fri, 2006-10-27 at 10:45 -0400, Alan Stern wrote:
> > James:
> > 
> > I haven't gotten any feedback about these two patch submissions, and they 
> > aren't in the current scsi-misc GIT:
> > 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=116059987422907&w=2
> 
> This one looks OK ... it's such a tiny micro optimisation, though.  I
> think I just lost it along the way, sorry.
> 
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=115947226830808&w=2
> 
> This one has warning phrases like "There are two potential weaknesses in
> the patch.  One is that when the bad
> sense data occurs, it unconditionally calls scsi_requeue_command().  Could
> this lead to an infinite loop?"  which aren't conducive to immediate application.
> 
> I'll take a look at it when I get some time.
> 
> James

Okay, thanks.  I just wanted to make sure they didn't vanish down a
black hole.

Alan Stern

