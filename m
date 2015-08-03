From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [TRIVIAL PATCH] block: Correct misuses of 0x%<decimal>
Date: Mon, 03 Aug 2015 09:20:20 +0200
Message-ID: <mqd614w6dor.fsf@c203.arch.suse.de>
References: <1438547113.29569.5.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1438547113.29569.5.camel@perches.com> (Joe Perches's message of
	"Sun, 02 Aug 2015 13:25:13 -0700")
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: Don Brace <don.brace@pmcs.com>, linux-kernel@vger.kernel.org, iss_storagedev@hp.com, storagedev@pmcs.com, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> Correct misuse of 0x%d in logging messages.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/block/DAC960.c | 4 ++--
>  drivers/block/cciss.c  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
> index 811e11c..d9b32f2 100644
> --- a/drivers/block/DAC960.c
> +++ b/drivers/block/DAC960.c
> @@ -2954,7 +2954,7 @@ DAC960_DetectController(struct pci_dev *PCI_Dev=
ice,
>         case DAC960_PD_Controller:
>           if (!request_region(Controller->IO_Address, 0x80,
>                               Controller->FullModelName)) {
> -               DAC960_Error("IO port 0x%d busy for Controller at\n",
> +               DAC960_Error("IO port 0x%x busy for Controller at\n",
>                              Controller, Controller->IO_Address);
>                 goto Failure;
>           }
> @@ -2990,7 +2990,7 @@ DAC960_DetectController(struct pci_dev *PCI_Dev=
ice,
>         case DAC960_P_Controller:
>           if (!request_region(Controller->IO_Address, 0x80,
>                               Controller->FullModelName)){
> -               DAC960_Error("IO port 0x%d busy for Controller at\n",
> +               DAC960_Error("IO port 0x%x busy for Controller at\n",
>                              Controller, Controller->IO_Address);
>                 goto Failure;
>           }
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 0422c47..2758982 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -3854,7 +3854,7 @@ static void print_cfg_table(ctlr_info_t *h)
>                readl(&(tb->HostWrite.CoalIntDelay)));
>         dev_dbg(&h->pdev->dev, "   Coalesce Interrupt Count =3D 0x%x\=
n",
>                readl(&(tb->HostWrite.CoalIntCount)));
> -       dev_dbg(&h->pdev->dev, "   Max outstanding commands =3D 0x%d\=
n",
> +       dev_dbg(&h->pdev->dev, "   Max outstanding commands =3D 0x%x\=
n",
>                readl(&(tb->CmdsOutMax)));
>         dev_dbg(&h->pdev->dev, "   Bus Types =3D 0x%x\n",
>                 readl(&(tb->BusTypes)));
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
