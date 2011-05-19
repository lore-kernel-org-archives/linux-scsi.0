From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Submit commit 3dea642afd for 2.6.38.stable?
Date: Thu, 19 May 2011 10:19:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1105191008150.1900-100000@iolanthe.rowland.org>
References: <1305777749.2576.10.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50291 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933264Ab1ESOT4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2011 10:19:56 -0400
In-Reply-To: <1305777749.2576.10.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Greg KH <greg@kroah.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, SCSI development list <linux-scsi@vger.kernel.org>, stable@kernel.org

On Thu, 19 May 2011, James Bottomley wrote:

> On Mon, 2011-05-16 at 16:45 -0400, Alan Stern wrote:
> > James:
> > 
> > Your commit 3dea642afd9187728d119fce5c82a7ed9faa9b6a ([SCSI] Revert
> > "[SCSI] Retrieve the Caching mode page") hasn't been submitted for the
> > 2.6.38 stable tree.  More people are now getting hit with the
> > underlying problem; see
> > 
> > 	https://bugzilla.kernel.org/show_bug.cgi?id=35042
> 
> OK, yes, the reversion needs sending to stable ... can you do that?

I'll handle it.

Greg, can you send the commit listed above directly into the stable 
queue, or should I email it to stable@kernel.org as a separate patch?  
It needs to be applied to 2.6.38.x only.

Alan Stern

