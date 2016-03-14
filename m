From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 4/5] Setting scsi host template to indicate that fnic
 does not support multiqueue
Date: Mon, 14 Mar 2016 16:16:17 -0400
Message-ID: <1457986577.4188.31.camel@localhost.localdomain>
References: <1457979262-26571-1-git-send-email-satishkh@cisco.com>
	 <1457979262-26571-4-git-send-email-satishkh@cisco.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49931 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187AbcCNUQS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2016 16:16:18 -0400
In-Reply-To: <1457979262-26571-4-git-send-email-satishkh@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satish Kharat <satishkh@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2016-03-14 at 11:14 -0700, Satish Kharat wrote:
> Fnic does not support mutiqueue. Setting the scsi_host_template in
> fnic_host_template to indicate that.
> 
> Changing fnic_version from 1.6.0.21 to 1.6.0.22
> 
> Signed-off-by: Satish Kharat <satishkh@cisco.com>
> ---
>  drivers/scsi/fnic/fnic.h      | 2 +-
>  drivers/scsi/fnic/fnic_main.c | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
> index 9ddc920..35264c7 100644
> --- a/drivers/scsi/fnic/fnic.h
> +++ b/drivers/scsi/fnic/fnic.h
> @@ -39,7 +39,7 @@
>  
>  #define DRV_NAME		"fnic"
>  #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
> -#define DRV_VERSION		"1.6.0.21"
> +#define DRV_VERSION		"1.6.0.22"
>  #define PFX			DRV_NAME ": "
>  #define DFX                     DRV_NAME "%d: "
>  
> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 58ce902..fa8a121 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
> @@ -119,6 +119,7 @@ static struct scsi_host_template fnic_host_template = {
>  	.max_sectors = 0xffff,
>  	.shost_attrs = fnic_attrs,
>  	.track_queue_depth = 1,
> +	.disable_blk_mq = 1,
>  };
>  
>  static void

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


