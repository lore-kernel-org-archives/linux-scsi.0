From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH] pm80xx: Added pm8006 controller support
Date: Tue, 24 Feb 2015 09:36:31 +0100
Message-ID: <CAD+HZHWRk06bJxEm8zsLPudGeJi96LMJxNd6STVKBF0k1=rphg@mail.gmail.com>
References: <1423722877-17436-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:59576 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbbBXIgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2015 03:36:32 -0500
Received: by mail-ob0-f175.google.com with SMTP id va2so42000412obc.6
        for <linux-scsi@vger.kernel.org>; Tue, 24 Feb 2015 00:36:31 -0800 (PST)
In-Reply-To: <1423722877-17436-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, James Bottomley <JBottomley@parallels.com>, Viswas G <Viswas.G@pmcs.com>, "pmchba@pmcs.com" <pmchba@pmcs.com>

Sorry for delay, I missed this patch.

Acked-by: Jack Wang <xjtuwjp@gmail.com>

2015-02-12 7:34 GMT+01:00 Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>:
> Added the pm8006 controller id in pci table
>
> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
> Signed-off-by: Viswas G <Viswas.G@pmcs.com>
> ---
>  drivers/scsi/pm8001/pm8001_defs.h |    3 ++-
>  drivers/scsi/pm8001/pm8001_init.c |    5 ++++-
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
> index 74a4bb9..dc4233b 100644
> --- a/drivers/scsi/pm8001/pm8001_defs.h
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> @@ -49,7 +49,8 @@ enum chip_flavors {
>         chip_8019,
>         chip_8074,
>         chip_8076,
> -       chip_8077
> +       chip_8077,
> +       chip_8006,
>  };
>
>  enum phy_speed {
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 6555591..e1aee58 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -57,6 +57,7 @@ static const struct pm8001_chip_info pm8001_chips[] = {
>         [chip_8074] = {0,  8, &pm8001_80xx_dispatch,},
>         [chip_8076] = {0,  16, &pm8001_80xx_dispatch,},
>         [chip_8077] = {0,  16, &pm8001_80xx_dispatch,},
> +       [chip_8006] = {0,  16, &pm8001_80xx_dispatch,},
>  };
>  static int pm8001_id;
>
> @@ -1108,6 +1109,8 @@ err_out_enable:
>   */
>  static struct pci_device_id pm8001_pci_table[] = {
>         { PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
> +       { PCI_VDEVICE(PMC_Sierra, 0x8006), chip_8006 },
> +       { PCI_VDEVICE(ADAPTEC2, 0x8006), chip_8006 },
>         { PCI_VDEVICE(ATTO, 0x0042), chip_8001 },
>         /* Support for SPC/SPCv/SPCve controllers */
>         { PCI_VDEVICE(ADAPTEC2, 0x8001), chip_8001 },
> @@ -1218,7 +1221,7 @@ MODULE_AUTHOR("Anand Kumar Santhanam <AnandKumar.Santhanam@pmcs.com>");
>  MODULE_AUTHOR("Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>");
>  MODULE_AUTHOR("Nikith Ganigarakoppal <Nikith.Ganigarakoppal@pmcs.com>");
>  MODULE_DESCRIPTION(
> -               "PMC-Sierra PM8001/8081/8088/8089/8074/8076/8077 "
> +               "PMC-Sierra PM8001/8006/8081/8088/8089/8074/8076/8077 "
>                 "SAS/SATA controller driver");
>  MODULE_VERSION(DRV_VERSION);
>  MODULE_LICENSE("GPL");
> --
> 1.7.1
>
