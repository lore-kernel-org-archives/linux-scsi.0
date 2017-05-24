From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 11/31] block: Introduce queue flag QUEUE_FLAG_SCSI_SUP
Date: Wed, 24 May 2017 08:01:14 +0200
Message-ID: <ff6777f8-eb90-224c-a615-3dca235d1d18@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-12-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966241AbdEXGBR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 02:01:17 -0400
In-Reply-To: <20170524003420.5381-12-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> From the context where a SCSI command is submitted it is not always
> possible to figure out whether or not the queue the command is
> submitted to has struct scsi_request as the first member of its
> private data. Hence introduce the flag QUEUE_FLAG_SCSI_SUP.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  block/bsg-lib.c                   | 1 +
>  drivers/block/cciss.c             | 1 +
>  drivers/ide/ide-probe.c           | 1 +
>  drivers/scsi/scsi_lib.c           | 2 ++
>  drivers/scsi/scsi_transport_sas.c | 1 +
>  include/linux/blkdev.h            | 2 ++
>  6 files changed, 8 insertions(+)
> 
Bit of an odd name; what about QUEUE_FLAG_SCSI_PDU?

Otherwise:
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
