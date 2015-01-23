From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 03/17] sg: Remove an unused variable
Date: Fri, 23 Jan 2015 13:30:07 +0100
Message-ID: <54C23ECF.20506@interlog.com>
References: <54C2390A.3000700@sandisk.com> <54C23978.9080202@sandisk.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44449 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755189AbbAWMaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jan 2015 07:30:11 -0500
In-Reply-To: <54C23978.9080202@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 15-01-23 01:07 PM, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c | 17 +----------------
>   1 file changed, 1 insertion(+), 16 deletions(-)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index b14f64c..a668c88 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -763,7 +763,7 @@ static int
>   sg_common_write(Sg_fd * sfp, Sg_request * srp,
>   		unsigned char *cmnd, int timeout, int blocking)
>   {
> -	int k, data_dir, at_head;
> +	int k, at_head;
>   	Sg_device *sdp = sfp->parentdp;
>   	sg_io_hdr_t *hp = &srp->header;
>
> @@ -793,21 +793,6 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
>   		return -ENODEV;
>   	}
>
> -	switch (hp->dxfer_direction) {
> -	case SG_DXFER_TO_FROM_DEV:
> -	case SG_DXFER_FROM_DEV:
> -		data_dir = DMA_FROM_DEVICE;
> -		break;
> -	case SG_DXFER_TO_DEV:
> -		data_dir = DMA_TO_DEVICE;
> -		break;
> -	case SG_DXFER_UNKNOWN:
> -		data_dir = DMA_BIDIRECTIONAL;
> -		break;
> -	default:
> -		data_dir = DMA_NONE;
> -		break;
> -	}
>   	hp->duration = jiffies_to_msecs(jiffies);
>   	if (hp->interface_id != '\0' &&	/* v3 (or later) interface */
>   	    (SG_FLAG_Q_AT_TAIL & hp->flags))
>

