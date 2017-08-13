From: Dave Carroll <david.carroll@microsemi.com>
Subject: RE: [PATCH 3/6] scsi: aacraid: constify pci_error_handlers
 structures
Date: Sun, 13 Aug 2017 02:32:23 +0000
Message-ID: <423FD6710FB8FB4F8728F93591889F9A5B3E16C1@avsrvexchmbx2.microsemi.net>
References: <1502516674-8918-1-git-send-email-Julia.Lawall@lip6.fr>
 <1502516674-8918-4-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:12265
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752216AbdHMCcz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Aug 2017 22:32:55 -0400
In-Reply-To: <1502516674-8918-4-git-send-email-Julia.Lawall@lip6.fr>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>
Cc: "bhumirks@gmail.com" <bhumirks@gmail.com>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

>=20
> These pci_error_handlers structures are only stored in the err_handler fi=
eld of a
> pci_driver structure, and this field is declared as const.  Thus the
> pci_error_handlers structures can be const too.
>=20
> Done with the help of Coccinelle.
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> ---
>  drivers/scsi/aacraid/linit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c =
index
> a8dedc3..2b978d8 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -2070,7 +2070,7 @@ static void aac_pci_resume(struct pci_dev *pdev)
>         dev_err(&pdev->dev, "aacraid: PCI error - resume\n");  }
>=20
> -static struct pci_error_handlers aac_pci_err_handler =3D {
> +static const struct pci_error_handlers aac_pci_err_handler =3D {
>         .error_detected         =3D aac_pci_error_detected,
>         .mmio_enabled           =3D aac_pci_mmio_enabled,
>         .slot_reset             =3D aac_pci_slot_reset,

Acked-by: Dave Carroll <david.carroll@microsemi.com>
