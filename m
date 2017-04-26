From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Re: [PATCH] scsi: stex: make S6flag static
Date: Wed, 26 Apr 2017 10:40:52 +0800
Message-ID: <05e23578-0bc9-ebcc-28cd-22b8e6a06f00@gmail.com>
References: <20170425173619.11955-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36841 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1432142AbdDZClF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2017 22:41:05 -0400
In-Reply-To: <20170425173619.11955-1-colin.king@canonical.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>, Charles <charles.chiou@tw.promise.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Promise_Linux@promise.com

Looks good to me.
Thanks for the improvement.

On 4/26/2017 1:36 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> This module specific flag can be made static as it does
> not need to be in global scope.
> 
 > Reviewed-by: Charles Chiou <charles.chiou@tw.promise.com>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/scsi/stex.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 0751561b59da..9b20643ab49d 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -363,7 +363,7 @@ struct st_card_info {
>   	u16 sts_count;
>   };
>   
> -int S6flag;
> +static int S6flag;
>   static int stex_halt(struct notifier_block *nb, ulong event, void *buf);
>   static struct notifier_block stex_notifier = {
>   	stex_halt, NULL, 0
> 
