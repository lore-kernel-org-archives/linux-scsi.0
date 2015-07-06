From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: remove scsi_show_sense_hdr()
Date: Mon, 06 Jul 2015 13:45:09 +0200
Message-ID: <559A6A45.5020907@suse.de>
References: <1436182325-85246-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39062 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754591AbbGFLpL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jul 2015 07:45:11 -0400
In-Reply-To: <1436182325-85246-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On 07/06/2015 01:32 PM, Hannes Reinecke wrote:
> Last caller is gone, so remove it.
>=20
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  include/scsi/scsi_dbg.h | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
> index f8170e9..56710e0 100644
> --- a/include/scsi/scsi_dbg.h
> +++ b/include/scsi/scsi_dbg.h
> @@ -12,8 +12,6 @@ extern size_t __scsi_format_command(char *, size_t,
>  				   const unsigned char *, size_t);
>  extern void scsi_show_extd_sense(const struct scsi_device *, const c=
har *,
>  				 unsigned char, unsigned char);
> -extern void scsi_show_sense_hdr(const struct scsi_device *, const ch=
ar *,
> -				const struct scsi_sense_hdr *);
>  extern void scsi_print_sense_hdr(const struct scsi_device *, const c=
har *,
>  				 const struct scsi_sense_hdr *);
>  extern void scsi_print_sense(const struct scsi_cmnd *);
>=20
Bah, have to retract this for now.
Is actually part of my ALUA update to be posted shortly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
