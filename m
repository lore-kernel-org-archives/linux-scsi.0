From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH 5/7] pm8001: fix typo
Date: Tue, 17 May 2016 16:55:44 +0200
Message-ID: <CAMGffEndkb=hjpf4n3-HAAsxAWJOX2rH=YCc6VkA-iETph5TyA@mail.gmail.com>
References: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr> <1463495926-13728-6-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1463495926-13728-6-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, lindar_liu <lindar_liu@usish.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, May 17, 2016 at 4:38 PM, Julia Lawall <Julia.Lawall@lip6.fr> wr=
ote:
> firmare -> firmware
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
>
> ---
>  drivers/scsi/pm8001/pm8001_init.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/=
pm8001_init.c
> index 6bd7bf4..fdbee8b4 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1249,7 +1249,7 @@ static int pm8001_pci_resume(struct pci_dev *pd=
ev)
>
>         /* Chip documentation for the 8070 and 8072 SPCv    */
>         /* states that a 500ms minimum delay is required    */
> -       /* before issuing commands.  Otherwise, the firmare */
> +       /* before issuing commands. Otherwise, the firmware */
>         /* will enter an unrecoverable state.               */
>
>         if (pm8001_ha->chip_id =3D=3D chip_8070 ||
>

Thanks,
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>

--=20
Mit freundlichen Gr=C3=BC=C3=9Fen,
Best Regards,

Jack Wang
