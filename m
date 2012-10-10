From: scameron@beardog.cce.hp.com
Subject: Re: [SCSI] hpsa: dial down lockup detection during firmware flash
Date: Wed, 10 Oct 2012 09:18:40 -0500
Message-ID: <20121010141840.GE3546@beardog.cce.hp.com>
References: <1349840858.6336.31.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30761 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab2JJOSw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2012 10:18:52 -0400
Content-Disposition: inline
In-Reply-To: <1349840858.6336.31.camel@deadeye.wl.decadent.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, scameron@beardog.cce.hp.com


Yes, I think so.  Thanks.

-- steve

On Wed, Oct 10, 2012 at 04:47:38AM +0100, Ben Hutchings wrote:
> Should this fix for hpsa be included in stable updates?  It looks like
> it would be needed in 3.2.y and 3.4.y, as lockup detection was
> introduced in 3.2 and the fix went into 3.5.
> 
> commit e85c59746957fd6e3595d02cf614370056b5816e
> Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> Date:   Tue May 1 11:43:42 2012 -0500
> 
>     [SCSI] hpsa: dial down lockup detection during firmware flash
> 
> Ben.
> 
> -- 
> Ben Hutchings
> Who are all these weirdos? - David Bowie, about L-Space IRC channel #afp


