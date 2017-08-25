From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 14/19] libsas: Remove a set-but-not-used variable
Date: Fri, 25 Aug 2017 17:51:45 +0200
Message-ID: <71d428bb-0401-f312-1035-a3574522c092@suse.de>
References: <20170823214009.15015-1-bart.vanassche@wdc.com>
 <20170823214009.15015-15-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42981 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933662AbdHYPvr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 11:51:47 -0400
In-Reply-To: <20170823214009.15015-15-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 08/23/2017 11:40 PM, Bart Van Assche wrote:
> This was detected by building with W=1.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/libsas/sas_scsi_host.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
> index 87e5079d816b..fc90b8c65860 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -855,7 +855,6 @@ int sas_target_alloc(struct scsi_target *starget)
>  int sas_slave_configure(struct scsi_device *scsi_dev)
>  {
>  	struct domain_device *dev = sdev_to_domain_dev(scsi_dev);
> -	struct sas_ha_struct *sas_ha;
>  
>  	BUG_ON(dev->rphy->identify.device_type != SAS_END_DEVICE);
>  
> @@ -864,8 +863,6 @@ int sas_slave_configure(struct scsi_device *scsi_dev)
>  		return 0;
>  	}
>  
> -	sas_ha = dev->port->ha;
> -
>  	sas_read_port_mode_page(scsi_dev);
>  
>  	if (scsi_dev->tagged_supported) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
