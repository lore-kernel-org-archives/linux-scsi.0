From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] scsi_error: fix scsi_eh_restore_cmnd() documentation
Date: Sun, 7 Jun 2009 15:39:54 +0200
Message-ID: <200906071539.55016.bzolnier@gmail.com>
References: <200904272054.22929.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37756 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbZFGNpA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2009 09:45:00 -0400
Received: by mail-fx0-f213.google.com with SMTP id 9so1594329fxm.37
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jun 2009 06:45:02 -0700 (PDT)
In-Reply-To: <200904272054.22929.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Monday 27 April 2009 20:54:22 Bartlomiej Zolnierkiewicz wrote:
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/scsi/scsi_error.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/scsi/scsi_error.c
> ===================================================================
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -641,9 +641,9 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
>  /**
>   * scsi_eh_restore_cmnd  - Restore a scsi command info as part of error recory
>   * @scmd:       SCSI command structure to restore
> - * @ses:        saved information from a coresponding call to scsi_prep_eh_cmnd
> + * @ses:        saved information from a coresponding call to scsi_eh_prep_cmnd
>   *
> - * Undo any damage done by above scsi_prep_eh_cmnd().
> + * Undo any damage done by above scsi_eh_prep_cmnd().
>   */
>  void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
>  {

ping?
