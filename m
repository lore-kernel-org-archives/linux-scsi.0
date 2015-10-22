From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: wd719x: Use module_pci_driver
Date: Thu, 22 Oct 2015 09:23:21 +0200
Message-ID: <1445498601.16404.19.camel@suse.de>
References: <1445467581-26377-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445467581-26377-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Fida Mohammad <fmthoker@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-10-22 at 04:16 +0530, Muhammad Falak R Wani wrote:
> Remove boilerplate code by using macro module_pci_driver.
> For drivers whose __init and __exit paths only register and
> unregister to the pci API, it is preferred to use this macro.
>=20
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
> =C2=A0drivers/scsi/wd719x.c | 13 +------------
> =C2=A01 file changed, 1 insertion(+), 12 deletions(-)
>=20
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index 2a9da2e..6d3bce3 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -976,18 +976,7 @@ static struct pci_driver wd719x_pci_driver =3D {
> =C2=A0	.remove =3D	wd719x_pci_remove,
> =C2=A0};
> =C2=A0
> -static int __init wd719x_init(void)
> -{
> -	return pci_register_driver(&wd719x_pci_driver);
> -}
> -
> -static void __exit wd719x_exit(void)
> -{
> -	pci_unregister_driver(&wd719x_pci_driver);
> -}
> -
> -module_init(wd719x_init);
> -module_exit(wd719x_exit);
> +module_pci_driver(wd719x_pci_driver);
> =C2=A0
> =C2=A0MODULE_DESCRIPTION("Western Digital WD7193/7197/7296 SCSI drive=
r");
> =C2=A0MODULE_AUTHOR("Ondrej Zary, Aaron Dewell, Juergen Gaertner");

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
