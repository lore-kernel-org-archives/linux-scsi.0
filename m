From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 07/11] scsi: remove use_blk_tcq Scsi_Host field
Date: Tue, 04 Nov 2014 09:46:42 +0100
Message-ID: <54589272.6050105@suse.de>
References: <1415087656-9491-1-git-send-email-hch@lst.de> <1415087656-9491-8-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888AbaKDIqo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Nov 2014 03:46:44 -0500
In-Reply-To: <1415087656-9491-8-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Robert Elliott <elliott@hp.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Bart van Assche <bvanassche@acm.org>, Jens Axboe <axboe@fb.com>, Kashyap Desai <kashyap.desai@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Mike Christie <michaelc@cs.wisc.edu>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, usb-storage@lists.one-eyed-alien.net

On 11/04/2014 08:54 AM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/scsi/scsi_host.h | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index f62143a..8bf2cb0 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -642,7 +642,6 @@ struct Scsi_Host {
>  	unsigned active_mode:2;
>  	unsigned unchecked_isa_dma:1;
>  	unsigned use_clustering:1;
> -	unsigned use_blk_tcq:1;
> =20
>  	/*
>  	 * Host has requested that no further requests come through for the
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
