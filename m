From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH] scsi_dh: Document alua_rtpg_queue() arguments
Date: Wed, 24 Jan 2018 08:00:50 +0100
Message-ID: <4bc88c92-4a7a-948b-ae5f-6d6a68736def@suse.com>
References: <20180123235003.25971-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:36424 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752355AbeAXHAx (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Wed, 24 Jan 2018 02:00:53 -0500
In-Reply-To: <20180123235003.25971-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>

On 01/24/2018 12:50 AM, Bart Van Assche wrote:
> Since commit 3a025e1d1c2e ("Add optional check for bad kernel-doc
> comments") building with W=1 causes warnings to appear for issues
> in kernel-doc headers. This patch avoids that the following warnings
> are reported when building with W=1:
> 
> drivers/scsi/device_handler/scsi_dh_alua.c:867: warning: No description found for parameter 'pg'
> drivers/scsi/device_handler/scsi_dh_alua.c:867: warning: No description found for parameter 'sdev'
> drivers/scsi/device_handler/scsi_dh_alua.c:867: warning: No description found for parameter 'qdata'
> drivers/scsi/device_handler/scsi_dh_alua.c:867: warning: No description found for parameter 'force'
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 022e421c2185..4b44325d1a82 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -876,6 +876,11 @@ static void alua_rtpg_work(struct work_struct *work)
>  
>  /**
>   * alua_rtpg_queue() - cause RTPG to be submitted asynchronously
> + * @pg: ALUA port group associated with @sdev.
> + * @sdev: SCSI device for which to submit an RTPG.
> + * @qdata: Information about the callback to invoke after the RTPG.
> + * @force: Whether or not to submit an RTPG if a work item that will submit an
> + *         RTPG already has been scheduled.
>   *
>   * Returns true if and only if alua_rtpg_work() will be called asynchronously.
>   * That function is responsible for calling @qdata->fn().
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
