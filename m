From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] fix sd open/remove race
Date: Fri, 9 Apr 2004 15:58:33 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0404091556220.1932-100000@ida.rowland.org>
References: <1081536338.2203.107.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:20740 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261704AbUDIT6f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Apr 2004 15:58:35 -0400
In-Reply-To: <1081536338.2203.107.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>

On 9 Apr 2004, James Bottomley wrote:

> On Fri, 2004-04-09 at 13:29, Alan Stern wrote:
> > 	I want to prevent anyone from acquiring a reference to the
> > 	object after the driver has decided that no more references
> > 	should be given out, i.e., after sd_remove has been called.
> > 	Hence I use the semaphore around the get and in the remove.
> 
> Well, but I think you're going to spend a lot of effort trying to do
> this.  I'm not convinced it's worth it.

If it was possible to set disk->private_data to NULL within sd_remove, I'd 
argue that it's no more effort than what you've done.  As it is though, 
I'm forced to agree.

Alan Stern

