From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] add bus signalling host attributes to spi transport
	class
Date: 27 Sep 2004 14:03:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096308226.1714.55.camel@mulgrave>
References: <0B1E13B586976742A7599D71A6AC733C02F1D9@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45492 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266864AbUI0SDt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 14:03:49 -0400
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1D9@xbl3.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2004-09-27 at 14:00, James.Smart@Emulex.Com wrote:
> 
> I believe the spi patch below requires the following fix:
> 
> diff -uNr scsi-target-2.6/drivers/scsi/scsi_transport_spi.c scsi-target-2.6.fix/drivers/scsi/scsi_transport_spi.c
> --- scsi-target-2.6/drivers/scsi/scsi_transport_spi.c	2004-09-27 00:29:19.000000000 -0400
> +++ scsi-target-2.6.fix/drivers/scsi/scsi_transport_spi.c	2004-09-27 00:30:07.000000000 -0400
> @@ -814,7 +814,7 @@
>  
>  	BUG_ON(count > SPI_HOST_ATTRS);
>  
> -	i->attrs[count] = NULL;
> +	i->host_attrs[count] = NULL;
>  
>  	return &i->t;

Yes, I already (quietly, since no-one else seemed to have noticed my
ineptitude) put it into the scsi-target-2.6 tree.

James


