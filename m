From: Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Fri, 22 Jan 2016 00:16:12 -0800
Message-ID: <20160122081612.GA13277@kroah.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
 <1453306765.2341.11.camel@HansenPartnership.com>
 <yq1lh7kp5lo.fsf@sermon.lab.mkp.net>
 <1453308449.2341.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50866 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbcAVIQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 03:16:15 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 78A3E210C0
	for <linux-scsi@vger.kernel.org>; Fri, 22 Jan 2016 03:16:14 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1453308449.2341.22.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, borntraeger@de.ibm.com

On Wed, Jan 20, 2016 at 08:47:29AM -0800, James Bottomley wrote:
> On Wed, 2016-01-20 at 11:40 -0500, Martin K. Petersen wrote:
> > > > > > > "James" == James Bottomley <
> > > > > > > James.Bottomley@HansenPartnership.com> writes:
> > 
> > James> We should mark the commit causing the problems, which went
> > into
> > James> 4.4 if I remember correctly:
> > 
> > James> Fixes: ca369d51b3e1649be4a72addd6d6a168cfb3f537 Cc:
> > James> stable@vger.kernel.org # 4.4+ Reviewed-by: James E.J.
> > Bottomley
> > James> <James.Bottomley@HansenPartnership.com>
> > 
> > I'll add the tags. The reason I didn't explicitly put 4.4+ is that 
> > the original commit has made its way quite far in various stable 
> > trees by now.
> 
> It has?  It wasn't tagged for stable.  However, if it got applied to
> stable trees, then we should certainly backport further.  I sort of
> hope the stable process uses the Fixes: tag to decide when to backport
> anyway, since the stable commit contains the original upstream sha256,
> they can certainly identify it.
> 
> Greg, are we OK not to bother with qualifying the cc: stable tag if we
> have a Fixes tag, or do you still want to see both?  Perhaps an
> addition to stable_kernel_rules.txt mentioning Fixes: might be useful
> as well.

I want to see a stable tag if you know it is relevant.  I do, when I
have the time, dig through the fixes: tags to see if they should also be
applied, but I don't always guarantee that I will get to them at all, so
don't count on that as a way to get a patch into a stable release.

thanks,

greg k-h
