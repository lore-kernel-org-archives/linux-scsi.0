From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/7] dm: Use BLK_MQ_S_STOPPED instead of
 QUEUE_FLAG_STOPPED in blk-mq code
Date: Thu, 29 Sep 2016 07:53:05 +0200
Message-ID: <d48c006d-f00a-3bd6-24f2-ee0790645d91@suse.de>
References: <dbb073e5-817b-c2bd-26b1-b12752a9d82b@sandisk.com>
 <03abff7f-c882-aae7-b5db-8ca9b56e6e3a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55420 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752887AbcI2FxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Sep 2016 01:53:07 -0400
In-Reply-To: <03abff7f-c882-aae7-b5db-8ca9b56e6e3a@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 09/29/2016 01:58 AM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-rq.c | 18 ++----------------
>  1 file changed, 2 insertions(+), 16 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
