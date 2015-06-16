From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [Patch V2 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6
 controller
Date: Tue, 16 Jun 2015 13:33:33 +0200
Message-ID: <20150616113333.GC2883@c203.arch.suse.de>
References: <1433986951-9033-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1433986951-9033-5-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37235 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbbFPLdf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Jun 2015 07:33:35 -0400
Content-Disposition: inline
In-Reply-To: <1433986951-9033-5-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rajinikanth.pandurangan@pmcs.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, aacraid@pmc-sierra.com, harry.yang@pmcs.com, mahesh.rajashekhara@pmcs.com, rich.bono@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com

On Wed, Jun 10, 2015 at 06:42:25PM -0700, rajinikanth.pandurangan@pmcs.=
com wrote:
> From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
>=20
> Description:
> 	Enable MSI interrupt mode for series-6 controller.
>=20
> Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.=
com>
> ---
>  drivers/scsi/aacraid/src.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
> index b147341..eb07b3d 100644
> --- a/drivers/scsi/aacraid/src.c
> +++ b/drivers/scsi/aacraid/src.c
> @@ -742,7 +742,7 @@ int aac_src_init(struct aac_dev *dev)
>  	if (dev->comm_interface !=3D AAC_COMM_MESSAGE_TYPE1)
>  		goto error_iounmap;
> =20
> -	dev->msi =3D aac_msi && !pci_enable_msi(dev->pdev);
> +	dev->msi =3D !pci_enable_msi(dev->pdev);
> =20
>  	dev->aac_msix[0].vector_no =3D 0;
>  	dev->aac_msix[0].dev =3D dev;
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
