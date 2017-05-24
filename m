From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 16/31] scsi: Make scsi_ioctl_reset() pass the request
 queue pointer to blk_rq_init()
Date: Wed, 24 May 2017 08:03:27 +0200
Message-ID: <d2d8d461-79c0-679a-2b46-d544a87fdb4f@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-17-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58134 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966308AbdEXGD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 02:03:29 -0400
In-Reply-To: <20170524003420.5381-17-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> A later patch will add a call to a request initialization function
> into blk_rq_init(). Hence make sure that all blk_rq_init() calls
> specify the request queue pointer. Since TMF callback functions in
> SCSI LLD drivers do not use request.q, this patch does not change
> the behavior of any SCSI driver.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_error.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
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
