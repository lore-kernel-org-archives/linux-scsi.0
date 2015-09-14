From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 06/14] lpfc:Make the function
 lpfc_sli4_mbox_completions_pending static in order to comply with function
 prototype
Date: Mon, 14 Sep 2015 09:36:15 +0200
Message-ID: <55F678EF.9010106@suse.de>
References: <55e4bd8d.880iZVpjZfJsbEZL%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40331 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbINHgQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2015 03:36:16 -0400
In-Reply-To: <55e4bd8d.880iZVpjZfJsbEZL%james.smart@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, linux-scsi@vger.kernel.org

On 08/31/2015 10:48 PM, James Smart wrote:
>=20
> From: Nicholas Krause <xerofoify@gmail.com>
>=20
> This makes the function lpfc_sli4_mbox_completion's definition
> static now in order to comply with its prototype being also
> declared as static too.
>=20
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> Signed-off-by: James Smart <james.smart@avagotech.com>
> ---
>  drivers/scsi/lpfc/lpfc_sli.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sl=
i.c
> index 4feb931..95d53c7 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -6696,7 +6696,7 @@ lpfc_mbox_timeout(unsigned long ptr)
>   * This function checks if any mailbox completions are present on th=
e mailbox
>   * completion queue.
>   **/
> -bool
> +static bool
>  lpfc_sli4_mbox_completions_pending(struct lpfc_hba *phba)
>  {
> =20
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

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
