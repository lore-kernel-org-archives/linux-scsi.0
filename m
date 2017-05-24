From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/31] Create two versions of
 scsi_internal_device_unblock()
Date: Wed, 24 May 2017 07:48:44 +0200
Message-ID: <3cc1fc64-245c-6aff-f3a5-c1f26f890124@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54015 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938289AbdEXFss (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 01:48:48 -0400
In-Reply-To: <20170524003420.5381-3-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> This will make it easier to serialize SCSI device state changes
> through a mutex.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  4 ++--
>  drivers/scsi/scsi_lib.c              | 46 +++++++++++++++++++++++++-----------
>  include/scsi/scsi_device.h           |  4 ++--
>  3 files changed, 36 insertions(+), 18 deletions(-)
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
