From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] hpsa: change SAS transport devices to bus 0.
Date: Wed, 9 Dec 2015 17:21:14 -0600
Message-ID: <C8F529F3-D668-473E-92D5-5261A147B9E5@linux.vnet.ibm.com>
References: <20151209211816.519.50876.stgit@brunhilda> <20151209211850.519.87076.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:32868 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbLIXVW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2015 18:21:22 -0500
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Wed, 9 Dec 2015 18:21:20 -0500
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id A28EC6E804A
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 18:09:27 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tB9NLIxG28246054
	for <linux-scsi@vger.kernel.org>; Wed, 9 Dec 2015 23:21:18 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tB9NLHFn003852
	for <linux-scsi@vger.kernel.org>; Wed, 9 Dec 2015 18:21:17 -0500
In-Reply-To: <20151209211850.519.87076.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com, linux-scsi@vger.kernel.org

> On Dec 9, 2015, at 3:18 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> sas transport places devices on bus 0 but driver was setting
> the bus to 3.
> 
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.h |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
> index ae5beda..fdd39fc 100644
> --- a/drivers/scsi/hpsa.h
> +++ b/drivers/scsi/hpsa.h
> @@ -400,7 +400,7 @@ struct offline_device_entry {
> #define HPSA_PHYSICAL_DEVICE_BUS	0
> #define HPSA_RAID_VOLUME_BUS		1
> #define HPSA_EXTERNAL_RAID_VOLUME_BUS	2
> -#define HPSA_HBA_BUS			3
> +#define HPSA_HBA_BUS			0

Is this not the same as using HPSA_PHYSICAL_DEVICE_BUS?

