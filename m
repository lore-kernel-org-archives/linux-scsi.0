From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 6/8] scsi: pm80xx: reduce indentation
Date: Wed, 2 Jan 2019 08:27:50 +0100
Message-ID: <CAMGffEkWoK_tgndeEa-TYFy+wbFyKW4B_rBcqC=HTB+FcV=Sjw@mail.gmail.com>
References: <1546185195-25676-1-git-send-email-Julia.Lawall@lip6.fr> <1546185195-25676-7-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1546185195-25676-7-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: Jack Wang <jinpu.wang@profitbricks.com>, kernel-janitors@vger.kernel.org, lindar_liu <lindar_liu@usish.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 30, 2018 at 5:29 PM Julia Lawall <Julia.Lawall@lip6.fr> wrote:
>
> Delete tab aligning a statement with the right hand side of a
> preceding assignment rather than the left hand side.
>
> Found with the help of Coccinelle.
>
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
Thanks, Julia.
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> ---
>  drivers/scsi/pm8001/pm8001_sas.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index b3be49d41375..44b630aceb12 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -657,7 +657,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
>                 if (dev->dev_type == SAS_SATA_DEV) {
>                         pm8001_device->attached_phy =
>                                 dev->rphy->identify.phy_identifier;
> -                               flag = 1; /* directly sata*/
> +                       flag = 1; /* directly sata*/
>                 }
>         } /*register this device to HBA*/
>         PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
>


-- 
Jack Wang
Linux Kernel Developer

1&1 IONOS Cloud GmbH | Greifswalder Str. 207 | 10405 Berlin | Germany
Phone: +49 30 57700-8042 | Fax: +49 30 57700-8598
E-mail: jinpu.wang@cloud.ionos.com | Web: www.ionos.de


Head Office: Berlin, Germany
District Court Berlin Charlottenburg, Registration number: HRB 125506 B
Executive Management: Christoph Steffens, Matthias Steinberg, Achim Weiss

Member of United Internet
