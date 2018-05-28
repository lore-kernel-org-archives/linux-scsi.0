From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH] scsi: pm80xx: fix spelling mistake "UNSORPORTED" -> "SUPPORTED"
Date: Mon, 28 May 2018 09:53:22 +0200
Message-ID: <CAMGffEnSJciLOESLUZNfyPiguJpaOBxNp5-NGE81ihBY5275kA@mail.gmail.com>
References: <20180526144218.9891-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180526144218.9891-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: lindar_liu <lindar_liu@usish.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, May 26, 2018 at 4:42 PM, Colin King <colin.king@canonical.com> wrot=
e:
> From: Colin Ian King <colin.king@canonical.com>
>
> Trivial fix to spelling mistake in pm8001_printk message text; also
> I believe NOT_UNSUPPORTED should probably be NOT_SUPPORTED. Also
> fix the indent of the pm8001_printk statement.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Thanks, Colin.

Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
> index db88a8e7ee0e..4dd6cad330e8 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3607,7 +3607,7 @@ int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8=
001_ha, void *piomb)
>                 break;
>         default:
>                 PM8001_MSG_DBG(pm8001_ha,
> -                pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_UNSORPORTE=
D\n"));
> +                       pm8001_printk("DEVREG_FAILURE_DEVICE_TYPE_NOT_SUP=
PORTED\n"));
>                 break;
>         }
>         complete(pm8001_dev->dcompletion);
> --
> 2.17.0
>



--=20
Jack Wang
Linux Kernel Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Tel:       +49 30 577 008  042
Fax:      +49 30 577 008 299
Email:    jinpu.wang@profitbricks.com
URL:      https://www.profitbricks.de

Sitz der Gesellschaft: Berlin
Registergericht: Amtsgericht Charlottenburg, HRB 125506 B
Gesch=C3=A4ftsf=C3=BChrer: Achim Weiss, Matthias Steinberg, Christoph Steff=
ens
