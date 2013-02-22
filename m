From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/15] pm80xx: fix for memory region free
Date: Fri, 22 Feb 2013 23:05:29 +0000
Message-ID: <1361574329.2372.59.camel@dabdike.int.hansenpartnership.com>
References: <511A34D1.4070207@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43482 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab3BVXFd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 18:05:33 -0500
In-Reply-To: <511A34D1.4070207@pmc-sierra.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anand <anandkumar_santhanam@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, jack_wang@usish.com, Sangeetha.Gnanasekaran@pmcs.com, Vishwanath.Maram@pmcs.com, Harry.Yang@pmcs.com

On Tue, 2013-02-12 at 04:25 -0800, Anand wrote:
> >From 56ee53f01663fa479c0624b81e36545ea5b1ab94 Mon Sep 17 00:00:00 2001
> From: Sakthivel K <Sakthivel.SaravananKamalRaju@pmcs.com>
> Date: Mon, 4 Feb 2013 12:10:02 +0530
> Subject: [PATCH 01/15] pm80xx: fix for memory region free
> 
> All memory regions are allocated based on variables total_len
> and alignment but free was based on element_size.
> 
> Signed-off-by: Sakthivel K <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>
> Signed-off-by: Anand Kumar S <DL.Team.PMC.SPC.Linux.open.source@pmcs.com>

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


