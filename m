From: Greg KH <greg@kroah.com>
Subject: Re: [stable] Submit commit 3dea642afd for 2.6.38.stable?
Date: Wed, 18 May 2011 17:27:27 -0700
Message-ID: <20110519002727.GD8697@kroah.com>
References: <Pine.LNX.4.44L0.1105161626070.2013-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46953 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753406Ab1ESA3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 20:29:34 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1105161626070.2013-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Luben Tuikov <ltuikov@yahoo.com>, stable@kernel.org

On Mon, May 16, 2011 at 04:45:15PM -0400, Alan Stern wrote:
> James:
> 
> Your commit 3dea642afd9187728d119fce5c82a7ed9faa9b6a ([SCSI] Revert
> "[SCSI] Retrieve the Caching mode page") hasn't been submitted for the
> 2.6.38 stable tree.  More people are now getting hit with the
> underlying problem; see
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=35042
> 
> Do you want to queue your commit to the stable tree, or do you prefer
> to wait until the proper repair patch:
> 
> 	http://marc.info/?l=linux-scsi&m=130089710431684&w=2
> 
> has been merged so it can go into the stable tree instead?
> 
> Alan Stern
> 
> P.S.: As of now, the scsi-next tree doesn't show any signs of
> reinstating Luben's original commit together with my repair patch.  
> Does this mean you intend to forget about the original "Retrieve the
> Caching mode page" change, or do you intend to merge them for 2.6.41?)

James, any ideas?

thanks,

greg k-h
