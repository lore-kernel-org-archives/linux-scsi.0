From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 10/12] scsi: Use DECLARE_BITMAP
Date: Wed, 20 May 2015 07:03:00 +0200
Message-ID: <555C1584.7070802@sandisk.com>
References: <cover.1432085659.git.joe@perches.com>
 <8854fb0135507c40546bd0c9a7890efbb38a9c96.1432085659.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0086.outbound.protection.outlook.com ([157.56.111.86]:55130
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751182AbbETFDJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 May 2015 01:03:09 -0400
In-Reply-To: <8854fb0135507c40546bd0c9a7890efbb38a9c96.1432085659.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org

On 05/20/15 03:37, Joe Perches wrote:
> Use the generic mechanism to declare a bitmap instead of unsigned long.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/scsi/sr.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 8bd54a6..f40c957 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -99,7 +99,7 @@ static struct scsi_driver sr_template = {
>   	.done			= sr_done,
>   };
>
> -static unsigned long sr_index_bits[SR_DISKS / BITS_PER_LONG];
> +static DECLARE_BITMAP(sr_index_bits, SR_DISKS);
>   static DEFINE_SPINLOCK(sr_index_lock);
>
>   /* This semaphore is used to mediate the 0->1 reference get in the

Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
