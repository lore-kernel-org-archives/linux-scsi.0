From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 6/6] pm80xx : corrected linkrate value.
Date: Tue, 29 Aug 2017 13:08:49 +0200
Message-ID: <CAD+HZHUmNh1phB5TqGV97Cj8C=q_WG=W3CBgvFenMGxLNmsFkw@mail.gmail.com>
References: <20150130060645.23653-1-Viswas.G@microsemi.com> <20150130060645.23653-7-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35811 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751361AbdH2LIv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 07:08:51 -0400
Received: by mail-wr0-f195.google.com with SMTP id a47so2053567wra.2
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2017 04:08:50 -0700 (PDT)
In-Reply-To: <20150130060645.23653-7-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <Viswas.G@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Vasanthalakshmi.Tharmarajan@microsemi.com

2015-01-30 7:06 GMT+01:00 Viswas G <Viswas.G@microsemi.com>:
> Corrected the value defined for LINKRATE_60 (6 Gig).
>
> Signed-off-by: Raj Dinesh <Raj.Dinesh@microsemi.com>
> Signed-off-by: Viswas G <viswas.g@microsemi.com>
> ---
>  drivers/scsi/pm8001/pm80xx_hwi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
> index d8e5d81e83f1..71dee83aeef0 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.h
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.h
> @@ -167,7 +167,7 @@
>  #define LINKMODE_AUTO                  (0x03 << 12)
>  #define LINKRATE_15                    (0x01 << 8)
>  #define LINKRATE_30                    (0x02 << 8)
> -#define LINKRATE_60                    (0x06 << 8)
> +#define LINKRATE_60                    (0x04 << 8)
>  #define LINKRATE_120                   (0x08 << 8)
>
>  /* phy_profile */
> --
> 2.12.3
>
Thanks Viswas, how did this happen, checked pm8001_hwi.h, it's right.
Anyway, looks good to me!
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>
