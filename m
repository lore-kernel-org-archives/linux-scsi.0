From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 23/23] scsi_dh_alua: Update version to 2.0
Date: Tue, 22 Sep 2015 16:05:56 -0400
Message-ID: <1442952356.4132.78.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-24-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933524AbbIVUF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 16:05:57 -0400
In-Reply-To: <1440679281-13234-24-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 3c6b365..5b15936 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -31,7 +31,7 @@
>  #include <scsi/scsi_dh.h>
>  
>  #define ALUA_DH_NAME "alua"
> -#define ALUA_DH_VER "1.3"
> +#define ALUA_DH_VER "2.0"
>  
>  #define TPGS_STATE_OPTIMIZED		0x0
>  #define TPGS_STATE_NONOPTIMIZED		0x1

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


