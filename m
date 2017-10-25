From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: .gitignore: Add scsi_devinfo_tbl.c
Date: Wed, 25 Oct 2017 11:35:35 +0200
Message-ID: <c94877cb-103d-d4cd-088f-118576389977@suse.de>
References: <20171025073910.1735-1-jeffy.chen@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48103 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932300AbdJYJfi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Oct 2017 05:35:38 -0400
In-Reply-To: <20171025073910.1735-1-jeffy.chen@rock-chips.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeffy Chen <jeffy.chen@rock-chips.com>, linux-kernel@vger.kernel.org, bart.vanassche@wdc.com, jthumshirn@suse.de, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>

On 10/25/2017 09:39 AM, Jeffy Chen wrote:
> Add generated scsi_devinfo_tbl.c into .gitignore.
> 
> Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
> ---
> 
>  drivers/scsi/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/.gitignore b/drivers/scsi/.gitignore
> index c89ae9a04399..e2956741fbd1 100644
> --- a/drivers/scsi/.gitignore
> +++ b/drivers/scsi/.gitignore
> @@ -1 +1,2 @@
>  53c700_d.h
> +scsi_devinfo_tbl.c
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
