From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/6] scsi-mq: Don't set QUEUE_FLAG_NONROT in
 scsi_mq_alloc_queue().
Date: Sun, 22 Dec 2013 22:33:00 -0800
Message-ID: <1387780380.5567.133.camel@haakon3.risingtidesystems.com>
References: <201311291641544409087@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60078 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab3LWGby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2013 01:31:54 -0500
In-Reply-To: <201311291641544409087@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-11-29 at 16:42 +0800, majianpeng wrote:
> This flag will be set in sd_revalidate_disk().So remove this operation.
> 
> Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> ---
>  drivers/scsi/scsi-mq.c |    2 --
>  1 file changed, 2 deletions(-)
> 

Applied, + squashed into current target-pending/scsi-mq code.

Thanks Jianpeng!

--nab

> diff --git a/drivers/scsi/scsi-mq.c b/drivers/scsi/scsi-mq.c
> index eccdbd5..933ba0f 100644
> --- a/drivers/scsi/scsi-mq.c
> +++ b/drivers/scsi/scsi-mq.c
> @@ -206,8 +206,6 @@ int scsi_mq_alloc_queue(struct Scsi_Host *sh, struct scsi_device *sdev)
>  			}
>  		}
>  	}
> -//FIXME: Check for !NONROT usage
> -	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
>  
>  	printk("scsi_mq_alloc_queue() complete !! >>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
>  	return 0;


