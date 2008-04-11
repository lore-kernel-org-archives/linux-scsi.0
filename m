From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 1/1] AIC94XX: Ports and Phys memory space fixed.
Date: Fri, 11 Apr 2008 10:16:27 -0700
Message-ID: <20080411171627.GB7112@tree.beaverton.ibm.com>
References: <FE3F06125A99254E8D92161AA4569C6F02BE7E62@sc-exch02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:33851 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760407AbYDKRQw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2008 13:16:52 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3BHGpMP025642
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2008 13:16:51 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3BHGk9X082276
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2008 11:16:51 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3BHGjbc005141
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2008 11:16:45 -0600
Content-Disposition: inline
In-Reply-To: <FE3F06125A99254E8D92161AA4569C6F02BE7E62@sc-exch02.marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jason Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Michael Wang <qswang@marvell.com>

On Thu, Apr 10, 2008 at 08:44:26PM -0700, Jason Chu wrote:
> No need more spaces for sas_phys and sas_port.
> 
> Signed-off-by:: Ying Chu <jasonchu@marvell.com>
> ---
> driver/scsi/aic94xx/aic94xx_init.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/aic94xx/aic94xx_init.c
> b/drivers/scsi/aic94xx/aic94xx_init.c
> index 88d1e73..0400bd2 100644
> --- a/drivers/scsi/aic94xx/aic94xx_init.c
> +++ b/drivers/scsi/aic94xx/aic94xx_init.c
> @@ -689,9 +689,9 @@ static int asd_register_sas_ha(struct as
>  {
>  	int i;
>  	struct asd_sas_phy   **sas_phys =
> -		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy),
> GFP_KERNEL);
> +		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy *),
> GFP_KERNEL);

Given that sas_phys is a pointer to pointers, I don't think that taking
the pointer out of the sizeof is the proper thing to do.

--D
