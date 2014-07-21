From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: add a symbolic name for the ZBC device type
Date: Mon, 21 Jul 2014 07:59:51 +0200
Message-ID: <53CCAC57.20403@suse.de>
References: <1405696638-23770-1-git-send-email-hch@lst.de> <1405696638-23770-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42329 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752461AbaGUF7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jul 2014 01:59:53 -0400
In-Reply-To: <1405696638-23770-3-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 07/18/2014 05:17 PM, Christoph Hellwig wrote:
> Make sure we have a symbolic name for the ZBC type available,
> so that e.g. patch for a SATA to translate ZAC commands can
> make use of it.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   include/scsi/scsi.h | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 91e2e42..e6df23c 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -332,6 +332,7 @@ static inline int scsi_status_is_good(int status)
>   #define TYPE_ENCLOSURE      0x0d    /* Enclosure Services Device */
>   #define TYPE_RBC	    0x0e
>   #define TYPE_OSD            0x11
> +#define TYPE_ZBC            0x14
>   #define TYPE_NO_LUN         0x7f
>
>   /* SCSI protocols; these are taken from SPC-3 section 7.5 */
>
Reviewed-by: Hannes Reinecke <hare@Suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
