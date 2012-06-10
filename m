From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: Re: [PATCH] [SCSI] qla2xxx: Get rid of unneeded includes of version.h
Date: Sun, 10 Jun 2012 12:48:56 +0530
Message-ID: <CAK9yfHysOb+FU-uppaRDYSWGJ=KEK6YhFifz9iS57ZFQDWc66Q@mail.gmail.com>
References: <alpine.LNX.2.00.1206100258400.15651@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34786 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2FJHS5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Jun 2012 03:18:57 -0400
Received: by vcbf11 with SMTP id f11so1639911vcb.19
        for <linux-scsi@vger.kernel.org>; Sun, 10 Jun 2012 00:18:56 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.00.1206100258400.15651@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-driver@qlogic.com, Andrew Vasquez <andrew.vasquez@qlogic.com>, trivial@kernel.org

Hi Jesper,

I have already submitted a similar patch for this:

http://www.spinics.net/lists/linux-scsi/msg59815.html



On 10 June 2012 06:29, Jesper Juhl <jj@chaosbits.net> wrote:
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> =A0drivers/scsi/qla2xxx/qla_target.c | =A0 =A01 -
> =A0drivers/scsi/qla2xxx/qla_target.h | =A0 =A02 --
> =A02 files changed, 3 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx=
/qla_target.c
> index 04f80eb..f7a49e4 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -26,7 +26,6 @@
> =A0#include <linux/module.h>
> =A0#include <linux/init.h>
> =A0#include <linux/types.h>
> -#include <linux/version.h>
> =A0#include <linux/blkdev.h>
> =A0#include <linux/interrupt.h>
> =A0#include <linux/pci.h>
> diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx=
/qla_target.h
> index 9ec19bc..7df4df5 100644
> --- a/drivers/scsi/qla2xxx/qla_target.h
> +++ b/drivers/scsi/qla2xxx/qla_target.h
> @@ -919,8 +919,6 @@ struct qla_tgt_srr_ctio {
> =A0#define QLA_TGT_XMIT_STATUS =A0 =A0 =A0 =A0 =A0 =A02
> =A0#define QLA_TGT_XMIT_ALL =A0 =A0 =A0 =A0 =A0 =A0 =A0 (QLA_TGT_XMIT=
_STATUS|QLA_TGT_XMIT_DATA)
>
> -#include <linux/version.h>
> -
> =A0extern struct qla_tgt_data qla_target;
> =A0/*
> =A0* Internal function prototypes
> --
> 1.7.10.4
>
>
> --
> Jesper Juhl <jj@chaosbits.net> =A0 =A0 =A0 http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/



--=20
With warm regards,
Sachin
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
