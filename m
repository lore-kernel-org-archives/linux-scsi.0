From: Bradley Grove <bgrove@attotech.com>
Subject: Re: [PATCH V2] [SCSI] esas2r: Fix comment
Date: Wed, 23 Apr 2014 16:41:17 -0400
Message-ID: <5358256D.6070504@attotech.com>
References: <1398191019-5018-1-git-send-email-marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sw.attotech.com ([208.69.85.34]:37188 "EHLO
	NOTESERV1.attotech.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932616AbaDWU41 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Apr 2014 16:56:27 -0400
In-Reply-To: <1398191019-5018-1-git-send-email-marex@denx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Marek Vasut <marex@denx.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <JBottomley@Parallels.com>, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>


This looks fine to me.

Acked-by: Bradley Grove <bgrove@attotech.com>

Thanks,
Brad

On 04/22/2014 02:23 PM, Marek Vasut wrote:
> Minor fix for a message in the driver so that it matches the function name.
>
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: James Bottomley <JBottomley@Parallels.com>
> Cc: Bradley Grove <bgrove@attotech.com>
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> ---
>   drivers/scsi/esas2r/esas2r_main.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> V2: Post to linux-scsi, tweak the commit message.
>
> diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
> index f37f3e3..6504a19 100644
> --- a/drivers/scsi/esas2r/esas2r_main.c
> +++ b/drivers/scsi/esas2r/esas2r_main.c
> @@ -390,7 +390,7 @@ static int esas2r_probe(struct pci_dev *pcid,
>   	esas2r_log_dev(ESAS2R_LOG_INFO, &(pcid->dev),
>   		       "pci_enable_device() OK");
>   	esas2r_log_dev(ESAS2R_LOG_INFO, &(pcid->dev),
> -		       "after pci_device_enable() enable_cnt: %d",
> +		       "after pci_enable_device() enable_cnt: %d",
>   		       pcid->enable_cnt.counter);
>
>   	host = scsi_host_alloc(&driver_template, host_alloc_size);
>

