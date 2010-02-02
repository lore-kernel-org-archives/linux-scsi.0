From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH] qla2xxx: negative error return in qla2x00_change_queue_depth()
Date: Tue, 2 Feb 2010 11:47:47 -0800
Message-ID: <BBAD2972-BD0C-4EF2-A842-3DC0E0022E77@qlogic.com>
References: <4B62B78F.2010404@gmail.com>
Mime-Version: 1.0 (Apple Message framework v912)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:55090 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136Ab0BBTrs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Feb 2010 14:47:48 -0500
In-Reply-To: <4B62B78F.2010404@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Driver <Linux-Driver@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

Acked-by: Giridhar Malavali <giridhar.malavali@qlogic.com>

On Jan 29, 2010, at 2:25 AM, Roel Kluin wrote:

> The *change_queue_depth functions usually return a negative error  
> return.
>
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/ 
> qla_os.c
> index 8529eb1..0753877 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1258,7 +1258,7 @@ qla2x00_change_queue_depth(struct scsi_device  
> *sdev, int qdepth, int reason)
> 		qla2x00_adjust_sdev_qdepth_up(sdev, qdepth);
> 		break;
> 	default:
> -		return EOPNOTSUPP;
> +		return -EOPNOTSUPP;
> 	}
>
> 	return sdev->queue_depth;

