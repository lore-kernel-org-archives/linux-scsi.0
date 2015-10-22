From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: wd719x: Remove use of macro
 DEFINE_PCI_DEVICE_TABLE
Date: Thu, 22 Oct 2015 09:22:47 +0200
Message-ID: <1445498567.16404.18.camel@suse.de>
References: <1445466207-23265-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445466207-23265-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-10-22 at 03:53 +0530, Muhammad Falak R Wani wrote:
> Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE with
> the goal of getting rid of this macro completely, as this macro
> is deprecated.
>=20
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
> =C2=A0drivers/scsi/wd719x.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index e3da1a2..2a9da2e 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -962,7 +962,7 @@ static void wd719x_pci_remove(struct pci_dev
> *pdev)
> =C2=A0	scsi_host_put(sh);
> =C2=A0}
> =C2=A0
> -static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) =3D {
> +static const struct pci_device_id wd719x_pci_table[] =3D {
> =C2=A0	{ PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
> =C2=A0	{}
> =C2=A0};

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
