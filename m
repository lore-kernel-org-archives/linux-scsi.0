From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] zfcp: Report FCP LUN to SCSI midlayer
Date: Tue, 19 Jun 2007 14:19:15 +0200
Message-ID: <4677C9C3.6040609@s5r6.in-berlin.de>
References: <200706191025.30986.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48156 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXFSMTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 08:19:21 -0400
In-Reply-To: <200706191025.30986.swen@vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Swen Schillig <swen@vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, christof.schmitt@de.ibm.com

Swen Schillig wrote:
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1213,7 +1213,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
>   *     Given a struct scsi_lun of: 0a 04 0b 03 00 00 00 00, this function returns
>   *     the integer: 0x0b030a04
>   **/
> -static int scsilun_to_int(struct scsi_lun *scsilun)
> +int scsilun_to_int(struct scsi_lun *scsilun)
>  {
>  	int i;
>  	unsigned int lun;
> @@ -1224,6 +1224,7 @@ static int scsilun_to_int(struct scsi_lun *scsilun)
>  			      scsilun->scsi_lun[i + 1]) << (i * 8));
>  	return lun;
>  }
> +EXPORT_SYMBOL(scsilun_to_int);

This export will be useful for fw-sbp2 too.
-- 
Stefan Richter
-=====-=-=== -==- =--==
http://arcgraph.de/sr/
