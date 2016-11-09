From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_devinfo: remove synchronous ALUA for NETAPP/RDAC
 devices
Date: Wed, 9 Nov 2016 07:49:59 +0100
Message-ID: <e6686f70-5de7-2618-0ba7-5a7b98eba068@suse.de>
References: <20161108193242.3454-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50315 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751226AbcKIGuC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 01:50:02 -0500
In-Reply-To: <20161108193242.3454-1-xose.vazquez@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Martin George <Martin.George@netapp.com>, Robert Stankey <Robert.Stankey@netapp.com>, Steven Schremmer <Steven.Schremmer@netapp.com>, Sean Stewart <Sean.Stewart@netapp.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, SCSI ML <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On 11/08/2016 08:32 PM, Xose Vazquez Perez wrote:
> NetApp did confirm this is only required for ONTAP(LUN C-Mode).
>
> Cc: Martin George <Martin.George@netapp.com>
> Cc: Robert Stankey <Robert.Stankey@netapp.com>
> Cc: Steven Schremmer <Steven.Schremmer@netapp.com>
> Cc: Sean Stewart <Sean.Stewart@netapp.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: SCSI ML <linux-scsi@vger.kernel.org>
> Cc: device-mapper development <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  drivers/scsi/scsi_devinfo.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
> index 2464569..1fb7964 100644
> --- a/drivers/scsi/scsi_devinfo.c
> +++ b/drivers/scsi/scsi_devinfo.c
> @@ -221,7 +221,6 @@ static struct {
>  	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
>  	{"NETAPP", "LUN C-Mode", NULL, BLIST_SYNC_ALUA},
> -	{"NETAPP", "INF-01-00", NULL, BLIST_SYNC_ALUA},
>  	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
>  	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
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
