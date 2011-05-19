From: Greg KH <greg@kroah.com>
Subject: Re: Submit commit 3dea642afd for 2.6.38.stable?
Date: Thu, 19 May 2011 08:28:35 -0700
Message-ID: <20110519152835.GA15620@kroah.com>
References: <1305777749.2576.10.camel@mulgrave.site>
 <Pine.LNX.4.44L0.1105191008150.1900-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33656 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505Ab1ESPdM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 11:33:12 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1105191008150.1900-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Luben Tuikov <ltuikov@yahoo.com>, SCSI development list <linux-scsi@vger.kernel.org>, stable@kernel.org

On Thu, May 19, 2011 at 10:19:54AM -0400, Alan Stern wrote:
> On Thu, 19 May 2011, James Bottomley wrote:
> 
> > On Mon, 2011-05-16 at 16:45 -0400, Alan Stern wrote:
> > > James:
> > > 
> > > Your commit 3dea642afd9187728d119fce5c82a7ed9faa9b6a ([SCSI] Revert
> > > "[SCSI] Retrieve the Caching mode page") hasn't been submitted for the
> > > 2.6.38 stable tree.  More people are now getting hit with the
> > > underlying problem; see
> > > 
> > > 	https://bugzilla.kernel.org/show_bug.cgi?id=35042
> > 
> > OK, yes, the reversion needs sending to stable ... can you do that?
> 
> I'll handle it.
> 
> Greg, can you send the commit listed above directly into the stable 
> queue, or should I email it to stable@kernel.org as a separate patch?  
> It needs to be applied to 2.6.38.x only.

Now queued up, all I needed was the git commit id above.

thanks,

greg k-h
