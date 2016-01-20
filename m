From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sd: Optimal I/O size is in bytes, not sectors
Date: Wed, 20 Jan 2016 08:47:29 -0800
Message-ID: <1453308449.2341.22.camel@HansenPartnership.com>
References: <1453305683-22424-1-git-send-email-martin.petersen@oracle.com>
	 <1453306765.2341.11.camel@HansenPartnership.com>
	 <yq1lh7kp5lo.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58978 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934698AbcATQrb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 11:47:31 -0500
In-Reply-To: <yq1lh7kp5lo.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, borntraeger@de.ibm.com, Greg Kroah-Hartman <greg@kroah.com>

On Wed, 2016-01-20 at 11:40 -0500, Martin K. Petersen wrote:
> > > > > > "James" == James Bottomley <
> > > > > > James.Bottomley@HansenPartnership.com> writes:
> 
> James> We should mark the commit causing the problems, which went
> into
> James> 4.4 if I remember correctly:
> 
> James> Fixes: ca369d51b3e1649be4a72addd6d6a168cfb3f537 Cc:
> James> stable@vger.kernel.org # 4.4+ Reviewed-by: James E.J.
> Bottomley
> James> <James.Bottomley@HansenPartnership.com>
> 
> I'll add the tags. The reason I didn't explicitly put 4.4+ is that 
> the original commit has made its way quite far in various stable 
> trees by now.

It has?  It wasn't tagged for stable.  However, if it got applied to
stable trees, then we should certainly backport further.  I sort of
hope the stable process uses the Fixes: tag to decide when to backport
anyway, since the stable commit contains the original upstream sha256,
they can certainly identify it.

Greg, are we OK not to bother with qualifying the cc: stable tag if we
have a Fixes tag, or do you still want to see both?  Perhaps an
addition to stable_kernel_rules.txt mentioning Fixes: might be useful
as well.

Thanks,

James

