From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Submit commit 3dea642afd for 2.6.38.stable?
Date: Thu, 19 May 2011 08:02:29 +0400
Message-ID: <1305777749.2576.10.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1105161626070.2013-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54708 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750722Ab1ESECi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2011 00:02:38 -0400
In-Reply-To: <Pine.LNX.4.44L0.1105161626070.2013-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, Luben Tuikov <ltuikov@yahoo.com>, SCSI development list <linux-scsi@vger.kernel.org>, stable@kernel.org

On Mon, 2011-05-16 at 16:45 -0400, Alan Stern wrote:
> James:
> 
> Your commit 3dea642afd9187728d119fce5c82a7ed9faa9b6a ([SCSI] Revert
> "[SCSI] Retrieve the Caching mode page") hasn't been submitted for the
> 2.6.38 stable tree.  More people are now getting hit with the
> underlying problem; see
> 
> 	https://bugzilla.kernel.org/show_bug.cgi?id=35042

OK, yes, the reversion needs sending to stable ... can you do that?

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

Actually, no, I was waiting for you to send the combined patch (with
both signoffs) rather than having me reconstruct it.

James


