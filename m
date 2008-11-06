From: Miquel van Smoorenburg <mikevs@xs4all.net>
Subject: Re: [PATCH] dpt_i2o.c: fix transferred data length for
 scsi_set_resid()
Date: Thu, 06 Nov 2008 16:48:23 +0100
Message-ID: <1225986503.10196.9.camel@n2o.xs4all.nl>
References: <20081104230908.GA21652@xs4all.net>
	 <4911A812.3020307@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:4684 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbYKFPsg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Nov 2008 10:48:36 -0500
In-Reply-To: <4911A812.3020307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>

On Wed, 2008-11-05 at 16:05 +0200, Boaz Harrosh wrote:
> Miquel van Smoorenburg wrote:
> > This should go into 2.6.28 and -stable, I think.
> > 
> > dpt_i2o-fix-xferlen-for-scsi_set_resid.patch
>
> 
> I do wish that someone could do a:
> +	scsi_set_resid(cmd, scsi_bufflen(cmd) - readl(REG_BYTE_COUNT));
> 
> or what ever. To prevent just these errors from happening.
>
> I understand that this is not your fault, but Just for the record, as a
> "TODO:" comment for us all.

Yes, dpt_i2o could use some more cleaning up. A while ago I said I'd
look at that (after I did the 64-bit support patches), but due to
circumstances I have even less time available than usual.

Anyway, this is the minimal patch for 2.6.28 and 2.6.27-stable, which is
correct for -rc and -stable patches, right ?

Mike.

