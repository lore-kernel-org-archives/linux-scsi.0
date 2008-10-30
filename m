From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] scsi/tmscsim: fix indentation and braces disagreement
 - add braces
Date: Thu, 30 Oct 2008 19:17:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0810301913280.8091@axis700.grange>
References: <Pine.LNX.4.64.0810301257110.7072@wrl-59.cs.helsinki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758599AbYJ3SRZ@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0810301257110.7072@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Nick Warne <nick@ukfsn.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 30 Oct 2008, Ilpo J=E4rvinen wrote:

>=20
> Lucky winner is 557cc476c04 ([SCSI] tmscsim: Fixup
> KERN_INFO in printk).
>=20
> Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@helsinki.fi>
> Cc: Nick Warne <nick@ukfsn.org>

Oops...:-(

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

> ---
>  drivers/scsi/tmscsim.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
> index 69ac6e5..9a42734 100644
> --- a/drivers/scsi/tmscsim.c
> +++ b/drivers/scsi/tmscsim.c
> @@ -2572,9 +2572,10 @@ static struct pci_driver dc390_driver =3D {
> =20
>  static int __init dc390_module_init(void)
>  {
> -	if (!disable_clustering)
> +	if (!disable_clustering) {
>  		printk(KERN_INFO "DC390: clustering now enabled by default. If you=
 get problems load\n");
>  		printk(KERN_INFO "       with \"disable_clustering=3D1\" and repor=
t to maintainers\n");
> +	}
> =20
>  	if (tmscsim[0] =3D=3D -1 || tmscsim[0] > 15) {
>  		tmscsim[0] =3D 7;
> --=20
> 1.5.2.2
>=20

---
Guennadi Liakhovetski, Ph.D.
=46reelance Open-Source Software Developer
