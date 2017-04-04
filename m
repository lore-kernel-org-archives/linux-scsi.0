From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sas: remove sas_domain_release_transport
Date: Tue, 4 Apr 2017 13:47:30 +0200
Message-ID: <2ebd1d14-24bd-dee4-9749-c818705035ca@suse.de>
References: <20170403143250.14125-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47965 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752896AbdDDLrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Apr 2017 07:47:33 -0400
In-Reply-To: <20170403143250.14125-1-jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>

On 04/03/2017 04:32 PM, Johannes Thumshirn wrote:
> sas_domain_release_transport is unused since at least v3.13, remove it.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/libsas/sas_init.c | 7 -------
>  include/scsi/libsas.h          | 1 -
>  2 files changed, 8 deletions(-)
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
