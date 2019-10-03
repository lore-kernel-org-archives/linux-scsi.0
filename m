Return-Path: <SRS0=749Z=X4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE65EC47404
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 02:31:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 861A9222C2
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 02:31:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="vCbxFpke"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727739AbfJCCbg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Oct 2019 22:31:36 -0400
Received: from conssluserg-04.nifty.com ([210.131.2.83]:28054 "EHLO
        conssluserg-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbfJCCbg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Oct 2019 22:31:36 -0400
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51]) (authenticated)
        by conssluserg-04.nifty.com with ESMTP id x932VA5s016359;
        Thu, 3 Oct 2019 11:31:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com x932VA5s016359
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1570069871;
        bh=Sj8hxll43sIAFFhXKFoQaRTifri22XaxlFEIaoPCHe4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vCbxFpkeS+kCNTY3x5Ew86/PvS4QNKBan00mUGzlPJHMHPV4xuiIwMA5k7MCaxxew
         qY053iVGk/MlogSIvLNl0ema8lu8Qv1zgx/9jrdulb/OqsZ+jFkYzOShbFeytY3AuR
         n1sRnBxSJT95wgezDGH8OnRSEt2QBVSMq40ZsUpTCVfE+qwpY+FWUH4B7DPv9MDckz
         CgxjmHlON4ZlLlhywCOZ2TDlEFbSv/cqViv7SxYDSIUCnuBWH4cOzNet1LfMMv8yPz
         2/w7X5UBvreLS3Y0f3pFxQ6w609tzJXW1IY+8Nv7G5ImMePWxMz6UqD4Rx2ISALwsd
         jCFnGKttsMKiQ==
X-Nifty-SrcIP: [209.85.222.51]
Received: by mail-ua1-f51.google.com with SMTP id b14so403793uap.6;
        Wed, 02 Oct 2019 19:31:10 -0700 (PDT)
X-Gm-Message-State: APjAAAWaHYL32xYFU9ikcG88oMWlWsEosIR9JCDmyBPKMgVkrDH030yz
        ErzQH94Eing5H7esPrqz052yhQlTxLWC8IyCQUg=
X-Google-Smtp-Source: APXvYqx2gjVyf0+CTjlkXwx2p3NsidAi0dZiMXhNgnEPzUCy8wzPGrZwXT1CTDtUGx6b/ps5GYkNbwiV4iVikUKuS5I=
X-Received: by 2002:a9f:21f6:: with SMTP id 109mr1467923uac.109.1570069869643;
 Wed, 02 Oct 2019 19:31:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190728164643.16335-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190728164643.16335-1-yamada.masahiro@socionext.com>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Thu, 3 Oct 2019 11:30:33 +0900
X-Gmail-Original-Message-ID: <CAK7LNATbahbn4W_71F8dZynXNb7Kbr5ZHb7mTV2_4oZok5AK=w@mail.gmail.com>
Message-ID: <CAK7LNATbahbn4W_71F8dZynXNb7Kbr5ZHb7mTV2_4oZok5AK=w@mail.gmail.com>
Subject: Re: [PATCH] scsi: ch: add include guard to chio.h
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On Mon, Jul 29, 2019 at 1:47 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> Add a header include guard just in case.
>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---

Ping?


>  include/uapi/linux/chio.h | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
>
> diff --git a/include/uapi/linux/chio.h b/include/uapi/linux/chio.h
> index 689fc93fafda..e1cad4c319ee 100644
> --- a/include/uapi/linux/chio.h
> +++ b/include/uapi/linux/chio.h
> @@ -3,6 +3,9 @@
>   * ioctl interface for the scsi media changer driver
>   */
>
> +#ifndef _UAPI_LINUX_CHIO_H
> +#define _UAPI_LINUX_CHIO_H
> +
>  /* changer element types */
>  #define CHET_MT   0    /* media transport element (robot) */
>  #define CHET_ST   1    /* storage element (media slots) */
> @@ -160,10 +163,4 @@ struct changer_set_voltag {
>  #define CHIOSVOLTAG    _IOW('c',18,struct changer_set_voltag)
>  #define CHIOGVPARAMS   _IOR('c',19,struct changer_vendor_params)
>
> -/* ---------------------------------------------------------------------- */
> -
> -/*
> - * Local variables:
> - * c-basic-offset: 8
> - * End:
> - */
> +#endif /* _UAPI_LINUX_CHIO_H */
> --
> 2.17.1
>


-- 
Best Regards
Masahiro Yamada
