From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND 10/18] megaraid_sas : megasas_complete_outstanding_ioctls()
 can be static
Date: Tue, 21 Apr 2015 12:33:25 +0200
Message-ID: <55362775.9090603@suse.de>
References: <201504201238.t3KCc8GM016945@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbbDUKd1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Apr 2015 06:33:27 -0400
In-Reply-To: <201504201238.t3KCc8GM016945@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

On 04/20/2015 02:35 PM, Sumit.Saxena@avagotech.com wrote:
> drivers/scsi/megaraid/megaraid_sas_base.c:1701:6: sparse: symbol 'meg=
asas_complete_outstanding_ioctls' was not declared. Should it be static=
?
>=20
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index 2424ab2..0381833 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -1695,7 +1695,7 @@ static int megasas_slave_alloc(struct scsi_devi=
ce *sdev)
>  * @instance:				Adapter soft state
>  *
>  */
> -void megasas_complete_outstanding_ioctls(struct megasas_instance *in=
stance)
> +static void megasas_complete_outstanding_ioctls(struct megasas_insta=
nce *instance)
>  {
>  	int i;
>  	struct megasas_cmd *cmd_mfi;
>=20
Reviewed-by: Hannes Reinecke <hare@suse.de>

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
