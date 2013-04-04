From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH 01/15] pm80xx: fix for memory region free
Date: Wed, 3 Apr 2013 23:27:34 -0700
Message-ID: <E5DEE6F468524847995699AD11E808850170026D@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <511A34D1.4070207@pmc-sierra.com> <1361574329.2372.59.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:43613 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698Ab3DDG1n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Apr 2013 02:27:43 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1361574329.2372.59.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, Vishwanath Maram <Vishwanath.Maram@pmcs.com>, Harry Yang <Harry.Yang@pmcs.com>, xjtuwjp@gmail.com

Hi James,

The patches for pm80xx driver has been resubmitted based on your review
feedback. Could you pls include the same for 3.9?

Regards
Anand

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Saturday, February 23, 2013 4:35 AM
To: Anand Kumar Santhanam
Cc: linux-scsi@vger.kernel.org; jack_wang@usish.com; Sangeetha
Gnanasekaran; Vishwanath Maram; Harry Yang
Subject: Re: [PATCH 01/15] pm80xx: fix for memory region free

On Tue, 2013-02-12 at 04:25 -0800, Anand wrote:
> >From 56ee53f01663fa479c0624b81e36545ea5b1ab94 Mon Sep 17 00:00:00 
> >2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 12:10:02 +0530
> Subject: [PATCH 01/15] pm80xx: fix for memory region free
> 
> All memory regions are allocated based on variables total_len and 
> alignment but free was based on element_size.
> 
> Signed-off-by: Sakthivel K 
> <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
> Signed-off-by: Anand Kumar S 
> <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>

This address doesn't resolve either

> Reporting-MTA: dns;bby1exg01.pmc_nt.nt.pmc-sierra.bc.ca
> Received-From-MTA: dns;bby1mta02.pmc-sierra.bc.ca
> Arrival-Date: Fri, 22 Feb 2013 10:19:53 -0800
> 
> Original-Recipient: rfc822;DL.Team.PMC.SPC.Linux.open.source@pmcs.com
> Final-Recipient: rfc822;DL.Team.PMC.SPC.Linux.open.source@pmcs.com
> Action: failed
> Status: 5.7.1
> X-Display-Name: DL Team PMC SPC Linux open source
> 
We need resolvable addresses for signoffs, please.

Thanks,

James


