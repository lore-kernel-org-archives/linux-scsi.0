From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH v2] megaraid: Downgrade two success messages to info
Date: Wed, 4 May 2016 12:29:48 +0530
Message-ID: <95c81e2c44ddd0219e1f1d6e017ddbff@mail.gmail.com>
References: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:34644 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbcEDG7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2016 02:59:50 -0400
Received: by mail-oi0-f48.google.com with SMTP id k142so54818454oib.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2016 23:59:50 -0700 (PDT)
In-Reply-To: <7e71f78a77208ec3f46f44e8c6dc6ebcff26c2ce.1462296213.git.luto@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>, Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Andy Lutomirski [mailto:luto@kernel.org]
> Sent: Tuesday, May 03, 2016 10:55 PM
> To: Kashyap Desai; Sumit Saxena; Uday Lingala
> Cc: megaraidlinux.pdl@avagotech.com; linux-scsi@vger.kernel.org; Andy
> Lutomirski
> Subject: [PATCH v2] megaraid: Downgrade two success messages to info
>
> I actually read the error messages in my logs, and successful
initialization is not
> an error.
>
> Arguably these log lines could be deleted entirely.
>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>
> Changes from v2: Remove hunk that didn't belong
>
> drivers/scsi/megaraid/megaraid_sas_base.c   | 2 +-
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index e6ebc7ae2df1..d020919e8085 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5152,7 +5152,7 @@ static int megasas_init_fw(struct megasas_instance
> *instance)
>
>  	instance->instancet->enable_intr(instance);
>
> -	dev_err(&instance->pdev->dev, "INIT adapter done\n");
> +	dev_info(&instance->pdev->dev, "INIT adapter done\n");
>
>  	megasas_setup_jbod_map(instance);
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index 98a848bdfdc2..9375805670a9 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -851,7 +851,7 @@ megasas_ioc_init_fusion(struct megasas_instance
> *instance)
>  		ret = 1;
>  		goto fail_fw_init;
>  	}
> -	dev_err(&instance->pdev->dev, "Init cmd success\n");
> +	dev_info(&instance->pdev->dev, "Init cmd success\n");
>
>  	ret = 0;
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

>
> --
> 2.5.5
