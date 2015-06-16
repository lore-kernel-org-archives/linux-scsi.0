From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [Patch V2 1/9] [SCSI] aacraid: Fix for logical device name and
 UID not exposed to the OS
Date: Tue, 16 Jun 2015 13:27:42 +0200
Message-ID: <20150616112742.GB2883@c203.arch.suse.de>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-3-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36842 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbFPL1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2015 07:27:48 -0400
Content-Disposition: inline
In-Reply-To: <1433986951-9033-3-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On Wed, Jun 10, 2015 at 06:42:23PM -0700, rajinikanth.pandurangan@pmcs.=
com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>=20
> Description:
> 	Driver sends the right size of the response buffer.
>=20
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.=
com>
> ---
>  drivers/scsi/aacraid/aachba.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aac=
hba.c
> index 9b3dd6e..fe59b00 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -570,7 +570,7 @@ static int aac_get_container_name(struct scsi_cmn=
d * scsicmd)
> =20
>  	status =3D aac_fib_send(ContainerCommand,
>  		  cmd_fibcontext,
> -		  sizeof (struct aac_get_name),
> +		  sizeof(struct aac_get_name_resp),
>  		  FsaNormal,
>  		  0, 1,
>  		  (fib_callback)get_container_name_callback,
> @@ -1052,7 +1052,7 @@ static int aac_get_container_serial(struct scsi=
_cmnd * scsicmd)
> =20
>  	status =3D aac_fib_send(ContainerCommand,
>  		  cmd_fibcontext,
> -		  sizeof (struct aac_get_serial),
> +		  sizeof(struct aac_get_serial_resp),
>  		  FsaNormal,
>  		  0, 1,
>  		  (fib_callback) get_container_serial_callback,
> --=20
> 1.9.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                       Storage
jthumshirn@suse.de                             +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
