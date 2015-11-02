From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 3/8] pm80xx: add ATTO PCI IDs to pm8001_pci_table
Date: Mon, 2 Nov 2015 09:02:20 +0100
Message-ID: <CAD+HZHX8FjzwrF+-EzXiH6NVo6QGgBcLgFFeMao-7ahBmi2H3A@mail.gmail.com>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
	<1446216811-2248-4-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34141 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbbKBICV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2015 03:02:21 -0500
Received: by lfgh9 with SMTP id h9so11330042lfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2015 00:02:20 -0800 (PST)
In-Reply-To: <1446216811-2248-4-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jej B <James.Bottomley@hansenpartnership.com>, Benjamin Rood <brood@attotech.com>

2015-10-30 15:53 GMT+01:00 Benjamin Rood <benjaminjrood@gmail.com>:
> These PCI IDs allow the pm8001 driver to load against ATTO 12Gb SAS
> controllers that use PMC Sierra 8070 and PMC Sierra 8072 SAS chips.
>
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 2106ac3..feaf504 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1181,6 +1181,20 @@ static struct pci_device_id pm8001_pci_table[] = {
>                 PCI_VENDOR_ID_ADAPTEC2, 0x0808, 0, 0, chip_8077 },
>         { PCI_VENDOR_ID_ADAPTEC2, 0x8074,
>                 PCI_VENDOR_ID_ADAPTEC2, 0x0404, 0, 0, chip_8074 },
> +       { PCI_VENDOR_ID_ATTO, 0x8070,
> +               PCI_VENDOR_ID_ATTO, 0x0070, 0, 0, chip_8070 },
> +       { PCI_VENDOR_ID_ATTO, 0x8070,
> +               PCI_VENDOR_ID_ATTO, 0x0071, 0, 0, chip_8070 },
> +       { PCI_VENDOR_ID_ATTO, 0x8072,
> +               PCI_VENDOR_ID_ATTO, 0x0072, 0, 0, chip_8072 },
> +       { PCI_VENDOR_ID_ATTO, 0x8072,
> +               PCI_VENDOR_ID_ATTO, 0x0073, 0, 0, chip_8072 },
> +       { PCI_VENDOR_ID_ATTO, 0x8070,
> +               PCI_VENDOR_ID_ATTO, 0x0080, 0, 0, chip_8070 },
> +       { PCI_VENDOR_ID_ATTO, 0x8072,
> +               PCI_VENDOR_ID_ATTO, 0x0081, 0, 0, chip_8072 },
> +       { PCI_VENDOR_ID_ATTO, 0x8072,
> +               PCI_VENDOR_ID_ATTO, 0x0082, 0, 0, chip_8072 },
>         {} /* terminate list */
>  };
>
> --
> 2.4.3
>
Reviewed-by: Jack Wang <jinpu.wang@profitbricks.com>

Thanks
Jack
