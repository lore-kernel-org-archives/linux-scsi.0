From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: fix kernel-doc, add kernel-doc
Date: Mon, 22 Feb 2010 12:51:25 +0100
Message-ID: <4B826FBD.7020000@s5r6.in-berlin.de>
References: <20100221194751.64b00c90.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44145 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab0BVLwA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2010 06:52:00 -0500
In-Reply-To: <20100221194751.64b00c90.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>, james.bottomley@suse.de

Randy Dunlap wrote:
> --- linux-2.6.33-rc8-git6.orig/drivers/scsi/scsi_scan.c
> +++ linux-2.6.33-rc8-git6/drivers/scsi/scsi_scan.c
[...]
> @@ -1920,17 +1917,12 @@ struct scsi_device *scsi_get_host_dev(st
>  EXPORT_SYMBOL(scsi_get_host_dev);
>  
>  /*

Should be /**.

> - * Function:    scsi_free_host_dev()
> - *
> - * Purpose:     Free a scsi_device that points to the host adapter itself.
> - *
> - * Arguments:   SHpnt   - Host that needs a scsi_device
> + * scsi_free_host_dev - Free a scsi_device that points to the host adapter itself
> + * @sdev: Host that needs a scsi_device

Perhaps: @sdev: Device to be freed

>   *
>   * Lock status: None assumed.
>   *
>   * Returns:     Nothing
> - *
> - * Notes:
>   */
>  void scsi_free_host_dev(struct scsi_device *sdev)
>  {

-- 
Stefan Richter
-=====-==-=- --=- =--==
http://arcgraph.de/sr/
