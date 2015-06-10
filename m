From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] megaraid_sas: insert missing space in kernel message
Date: Wed, 10 Jun 2015 08:30:16 +0200
Message-ID: <20150610063016.GA2780@c203.arch.suse.de>
References: <1433865223-15310-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433865223-15310-1-git-send-email-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 09, 2015 at 04:53:43PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>=20
> The printk format specifier string is missing a space between
> the %p format specifier and the "on the defer" text. Minor fix,
> add the missing space.
>=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index 890637f..4889ef6 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3148,7 +3148,7 @@ megasas_internal_reset_defer_cmds(struct megasa=
s_instance *instance)
>  		cmd =3D instance->cmd_list[i];
>  		if (cmd->sync_cmd =3D=3D 1 || cmd->scmd) {
>  			printk(KERN_NOTICE "megasas: moving cmd[%d]:%p:%d:%p"
> -					"on the defer queue as internal\n",
> +					" on the defer queue as internal\n",
>  				defer_index, cmd, cmd->sync_cmd, cmd->scmd);
> =20
>  			if (!list_empty(&cmd->list)) {
> --=20
> 2.1.4
>=20

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
