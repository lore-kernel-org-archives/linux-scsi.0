From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH] scsi: fix scsi_device_lookup_by_target() documentation
Date: Sun, 7 Jun 2009 15:39:36 +0200
Message-ID: <200906071539.37073.bzolnier@gmail.com>
References: <200904272054.16632.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:55405 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZFGNo6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Jun 2009 09:44:58 -0400
Received: by mail-bw0-f213.google.com with SMTP id 9so2497541bwz.37
        for <linux-scsi@vger.kernel.org>; Sun, 07 Jun 2009 06:45:00 -0700 (PDT)
In-Reply-To: <200904272054.16632.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

On Monday 27 April 2009 20:54:16 Bartlomiej Zolnierkiewicz wrote:
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/scsi/scsi.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: b/drivers/scsi/scsi.c
> ===================================================================
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -1225,8 +1225,8 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_ta
>   * @starget:	SCSI target pointer
>   * @lun:	SCSI Logical Unit Number
>   *
> - * Description: Looks up the scsi_device with the specified @channel, @id, @lun
> - * for a given host.  The returned scsi_device has an additional reference that
> + * Description: Looks up the scsi_device with the specified @lun for a given
> + * @starget.  The returned scsi_device has an additional reference that
>   * needs to be released with scsi_device_put once you're done with it.
>   **/
>  struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,

ping?
