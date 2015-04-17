From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v4 43/43] hpsa: add in new controller id
Date: Fri, 17 Apr 2015 15:37:50 +0200
Message-ID: <55310CAE.5000604@suse.de>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416135037.30238.63728.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933726AbbDQNhw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:37:52 -0400
In-Reply-To: <20150416135037.30238.63728.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:50 PM, Don Brace wrote:
> add in support for latest PMC controller
>=20
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
>  drivers/scsi/hpsa.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 5fc4118..910d748 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -132,6 +132,7 @@ static const struct pci_device_id hpsa_pci_device=
_id[] =3D {
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
> +	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0580},
>  	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
>  	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
>  	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
> @@ -189,6 +190,7 @@ static struct board_type products[] =3D {
>  	{0x21CC103C, "Smart Array", &SA5_access},
>  	{0x21CD103C, "Smart Array", &SA5_access},
>  	{0x21CE103C, "Smart HBA", &SA5_access},
> +	{0x05809005, "SmartHBA-SA", &SA5_access},
>  	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
>  	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
>  	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
Reviewed-by: Hannes Reinecke <hare@Suse.de>

Although I would have preferred the version increase to be the last
patch of the series; making easier to tracking driver versions.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
