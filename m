From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 6/7] bnx2fc: Add HZ to task management timeout.
Date: Wed, 21 Oct 2015 12:30:49 +0200
Message-ID: <56276959.2010100@suse.de>
References: <1445283641-7358-1-git-send-email-chad.dupuis@qlogic.com> <1445283641-7358-7-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbbJUKau (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2015 06:30:50 -0400
In-Reply-To: <1445283641-7358-7-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>, James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On 10/19/2015 09:40 PM, Chad Dupuis wrote:
> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2f=
c.h
> index d46267d..d05866d 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc.h
> +++ b/drivers/scsi/bnx2fc/bnx2fc.h
> @@ -129,7 +129,7 @@
>  #define BNX2FC_MAX_FCP_TGT		256
>  #define BNX2FC_MAX_CMD_LEN		16
> =20
> -#define BNX2FC_TM_TIMEOUT		60	/* secs */
> +#define BNX2FC_TM_TIMEOUT		(60 * HZ) /* seconds */
>  #define BNX2FC_IO_TIMEOUT		20000UL	/* msecs */
> =20
>  #define BNX2FC_WAIT_CNT			1200
>=20
Retracted, so no review :-)

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
