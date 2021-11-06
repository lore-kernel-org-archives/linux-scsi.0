Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA3D4C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 16:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C128261165
	for <linux-scsi@archiver.kernel.org>; Sat,  6 Nov 2021 16:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233310AbhKFQyS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 6 Nov 2021 12:54:18 -0400
Received: from mail-vk1-f174.google.com ([209.85.221.174]:35729 "EHLO
        mail-vk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbhKFQyR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 6 Nov 2021 12:54:17 -0400
Received: by mail-vk1-f174.google.com with SMTP id u130so6111582vku.2;
        Sat, 06 Nov 2021 09:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R9PO0YzwC2Jw+Hhm1KmFXfAei65K8Unw+7A6Xi9XIdM=;
        b=AprHLVYC68mFjVrjQ4lqLlZbTEwaVZ8CctKYpsxeijSs5JNeizPvDJp6Sex2nw1L+Y
         T1FI2yBdNB38fAREOAL/T3TVNddik2cQShAZhIlgww6KdLx5haxAebtcRaBa9256Pmrr
         FePYdY9wkD9KgjIvX04n0ykS/5e94WgT3FkAZgiHycbOFUujf7ajqsAtgk99VE+tsGAd
         TH+1weKUCG0fdHLiP1Ky2MmhyqNz4NJ80bot7uJqyOy/M6ihRvssW/vAeAQx7nxGWCqJ
         TuMUSCJiG+hBjCA4EOrxsjL6H67iYAgxDqzeECYkptglGsVHuyOv+xOuEjqYN0dRxTcf
         AyvQ==
X-Gm-Message-State: AOAM530rWNRZrTnbMp91MmbN+Oyx52nYiZ5NjjfAHkNkCc7xvRn2FgMP
        ABUxEf+ijVTEvFxCKCc4xBOeO81DmFI8dA==
X-Google-Smtp-Source: ABdhPJwSxbm0Oj00JEuVMrHoPrNeHhw6eIQl3WFx37SpxV5Y3O71w7coDZFBfqm13zx6fmL/1+4siw==
X-Received: by 2002:a1f:2345:: with SMTP id j66mr81593322vkj.20.1636217495538;
        Sat, 06 Nov 2021 09:51:35 -0700 (PDT)
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com. [209.85.221.174])
        by smtp.gmail.com with ESMTPSA id r25sm1830298uab.13.2021.11.06.09.51.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 09:51:35 -0700 (PDT)
Received: by mail-vk1-f174.google.com with SMTP id e64so6137640vke.4;
        Sat, 06 Nov 2021 09:51:35 -0700 (PDT)
X-Received: by 2002:a05:6122:20ab:: with SMTP id i43mr3542895vkd.19.1636217494892;
 Sat, 06 Nov 2021 09:51:34 -0700 (PDT)
MIME-Version: 1.0
References: <DM6PR04MB6575F2F6841B0573560E10ADFCA49@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20210927084615.1938432-1-anders.roxell@linaro.org>
In-Reply-To: <20210927084615.1938432-1-anders.roxell@linaro.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Sat, 6 Nov 2021 17:51:23 +0100
X-Gmail-Original-Message-ID: <CAMuHMdU53qiLwkx4XdB=SvjeeXLHCjn=kTZbT45YQv6KVRfR4g@mail.gmail.com>
Message-ID: <CAMuHMdU53qiLwkx4XdB=SvjeeXLHCjn=kTZbT45YQv6KVRfR4g@mail.gmail.com>
Subject: Re: [PATCHv2] scsi: ufs: Kconfig: SCSI_UFS_HWMON depens on HWMON=y
To:     Anders Roxell <anders.roxell@linaro.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>, avri.altman@wdc.com,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-hwmon@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Anders,

On Mon, Sep 27, 2021 at 10:47 AM Anders Roxell <anders.roxell@linaro.org> wrote:
> When building an allmodconfig kernel, the following build error shows
> up:
>
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_probe':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:177: undefined reference to `hwmon_device_register_with_info'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:177:(.text+0x510): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_device_register_with_info'
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_remove':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:195: undefined reference to `hwmon_device_unregister'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:195:(.text+0x5c8): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_device_unregister'
> aarch64-linux-gnu-ld: drivers/scsi/ufs/ufs-hwmon.o: in function `ufs_hwmon_notify_event':
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:206: undefined reference to `hwmon_notify_event'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:206:(.text+0x64c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_notify_event'
> aarch64-linux-gnu-ld: /home/anders/src/kernel/next/drivers/scsi/ufs/ufs-hwmon.c:209: undefined reference to `hwmon_notify_event'
> /kernel/next/drivers/scsi/ufs/ufs-hwmon.c:209:(.text+0x66c): relocation truncated to fit: R_AARCH64_CALL26 against undefined symbol `hwmon_notify_event'
>
> Since fragment 'SCSI_UFS_HWMON' can't be build as a module,
> 'SCSI_UFS_HWMON' has to depend on 'HWMON=y'.
>
> Fixes: e88e2d32200a ("scsi: ufs: core: Probe for temperature notification support")
> Also-Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
> Acked-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index 565e8aa6319d..2ca69f87e4de 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -202,7 +202,7 @@ config SCSI_UFS_FAULT_INJECTION
>
>  config SCSI_UFS_HWMON
>         bool "UFS  Temperature Notification"
> -       depends on SCSI_UFSHCD && HWMON
> +       depends on SCSI_UFSHCD=HWMON || HWMON=y

Which is also true if both SCSI_UFSHCD and HWMON are disabled,
thus exposing this question to everyone?

Fix sent
"[PATCH] scsi: ufs: Wrap Universal Flash Storage drivers in SCSI_UFSHCD"
https://lore.kernel.org/all/20211106164650.1571068-1-geert@linux-m68k.org/

>         help
>           This provides support for UFS hardware monitoring. If enabled,
>           a hardware monitoring device will be created for the UFS device.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
