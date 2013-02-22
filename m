From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 01/15] pm80xx: fix for memory region free
Date: Fri, 22 Feb 2013 16:06:35 +0000
Message-ID: <1361549195.2372.39.camel@dabdike.int.hansenpartnership.com>
References: <511A34D1.4070207@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42323 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757553Ab3BVQGk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2013 11:06:40 -0500
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
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 4c9fe73..3d5e522 100755

Can you please fix whatever it is you're doing that's causing this.  The
100755 at the end of the index directive indicates that you've
incorrectly added execute permissions to the file.  I've stripped all
these off again, but it's annoying.

Thanks,

James


