From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mpt fusion - resend negotiation parameters afterhost reset and resume
Date: Tue, 18 Apr 2006 17:58:57 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70081184@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:59893 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1750868AbWDRX7A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 19:59:00 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

On Tuesday, April 18, 2006 5:23 PM, James Bottomley wrote: 
> 
> You probably want to use spi_schedule_dv() here instead of 
> this for all
> cases, don't you?

I was merely implementing this code as it existed prior to 
spi transport additions.  Meaning we would only send out
the saved values from the previous dv run, not actually run
dv all over again.  

Are there other spi drivers that do this?  I greped the tree,
and couldn't find one that ran dv all over again after 
a host reset.   

I guess its possible that someone could of swapping out or 
cutting a cable, then it would make sense to have dv kick started
again after reset, right?  Is that your concern?  

Eric
