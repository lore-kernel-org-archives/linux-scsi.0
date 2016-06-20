From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH 1/3] scsi: Move 'scsi_attach_vpd()' prototype to
 scsi_priv.h
Date: Mon, 20 Jun 2016 09:24:46 -0400
Message-ID: <1466429086.4039.14.camel@localhost.localdomain>
References: <1466405868-87720-1-git-send-email-hare@suse.de>
	 <1466405868-87720-2-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbcFTNZk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2016 09:25:40 -0400
In-Reply-To: <1466405868-87720-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, 2016-06-20 at 08:57 +0200, Hannes Reinecke wrote:
> scsi_attach_vpd() is not exported, so it should be in scsi_priv.h.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi_priv.h   | 1 +
>  include/scsi/scsi_device.h | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 57a4b99..6c3db56 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -31,6 +31,7 @@ extern void scsi_exit_hosts(void);
>  /* scsi.c */
>  extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
>  extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
> +void scsi_attach_vpd(struct scsi_device *sdev);
>  #ifdef CONFIG_SCSI_LOGGING
>  void scsi_log_send(struct scsi_cmnd *cmd);
>  void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index a6c346d..3f2f147 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -314,7 +314,6 @@ extern int scsi_add_device(struct Scsi_Host *host, uint channel,
>  extern int scsi_register_device_handler(struct scsi_device_handler *scsi_dh);
>  extern void scsi_remove_device(struct scsi_device *);
>  extern int scsi_unregister_device_handler(struct scsi_device_handler *scsi_dh);
> -void scsi_attach_vpd(struct scsi_device *sdev);
>  
>  extern int scsi_device_get(struct scsi_device *);
>  extern void scsi_device_put(struct scsi_device *);

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


