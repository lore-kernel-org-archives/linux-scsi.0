From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/28] scsi: fix comment in scsi_device_set_state()
Date: Wed, 28 Jun 2017 15:54:58 +0200
Message-ID: <20170628135458.GC1268@lst.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de> <1498638316-44420-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:49514 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751495AbdF1Ny7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 09:54:59 -0400
Content-Disposition: inline
In-Reply-To: <1498638316-44420-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

On Wed, Jun 28, 2017 at 10:24:49AM +0200, Hannes Reinecke wrote:
> The function returns '0' if successful; with the original comment
> the function doesn't have a way to indicate success ...
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bart van Assche <bvanassche@wdc.com>
> ---
>  drivers/scsi/scsi_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 41c19c7..1ff7d72 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2547,7 +2547,7 @@ void scsi_exit_queue(void)
>   *	@sdev:	scsi device to change the state of.
>   *	@state:	state to change to.
>   *
> - *	Returns zero if unsuccessful or an error if the requested 
> + *	Returns zero if successful or an error if the requested
>   *	transition is illegal.
>   */
>  int
> -- 
> 1.8.5.6
---end quoted text---
