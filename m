From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 06/23] scsi_dh_alua: fixup description of stpg_endio()
Date: Tue, 22 Sep 2015 14:36:07 -0400
Message-ID: <1442946967.4132.8.camel@localhost.localdomain>
References: <1440679281-13234-1-git-send-email-hare@suse.de>
	 <1440679281-13234-7-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbbIVSgJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Sep 2015 14:36:09 -0400
In-Reply-To: <1440679281-13234-7-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Thu, 2015-08-27 at 14:41 +0200, Hannes Reinecke wrote:
> Fixup copy-and-paste error in the description of stpg_endio().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index c41d662..25c2045 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -174,13 +174,11 @@ done:
>  }
>  
>  /*
> - * alua_stpg - Evaluate SET TARGET GROUP STATES
> + * stpg_endio - Evaluate SET TARGET GROUP STATES
>   * @sdev: the device to be evaluated
>   * @state: the new target group state
>   *
> - * Send a SET TARGET GROUP STATES command to the device.
> - * We only have to test here if we should resubmit the command;
> - * any other error is assumed as a failure.
> + * Evaluate a SET TARGET GROUP STATES command response.
>   */
>  static void stpg_endio(struct request *req, int error)
>  {

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


