Return-Path: <SRS0=5ueY=ZC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85779C43331
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 09:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5434D207FA
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Nov 2019 09:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfKJJ3c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 04:29:32 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:48738 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726641AbfKJJ3b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 Nov 2019 04:29:31 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iTjAg-0000NX-6F; Sun, 10 Nov 2019 10:06:10 +0100
Received: from mail-wr1-f53.google.com ([209.85.221.53])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iTjAg-00033v-1z; Sun, 10 Nov 2019 10:06:10 +0100
Received: by mail-wr1-f53.google.com with SMTP id i12so4518836wro.5;
        Sun, 10 Nov 2019 01:06:09 -0800 (PST)
X-Gm-Message-State: APjAAAVF43xfiJbW5aVgiFDRKvG73Lo4iO13lL8KExIpXTPYwH9JyyZ8
        3caV5UvI69A4VBiY398dVYA/7TDWGXo0Uv4Z6Nc=
X-Google-Smtp-Source: APXvYqxPoz4E/tuTgkF3wppXFGa/kyDMrvgCNKgjwljO6CQjqsKC1PWJfHiMI4Trv2xHE0Ga44ze/skOMHq5mTYOEMk=
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr15337939wrx.310.1573376769850;
 Sun, 10 Nov 2019 01:06:09 -0800 (PST)
MIME-Version: 1.0
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
 <20191109191400.8999-1-jongk@linux-m68k.org> <alpine.LNX.2.21.1.1911100936080.8@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1.1911100936080.8@nippy.intranet>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Sun, 10 Nov 2019 10:06:22 +0100
X-Gmail-Original-Message-ID: <CACz-3rjCWu9Xq86cjiAR4c=5ybHHWej=J1sUmX1zkbL_C_Nsmw@mail.gmail.com>
Message-ID: <CACz-3rjCWu9Xq86cjiAR4c=5ybHHWej=J1sUmX1zkbL_C_Nsmw@mail.gmail.com>
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.53
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=8981fWPbAAAA:8 a=O8UfT5bJTs0MqBNrrnsA:9 a=aloc2OoSEsq5W06C:21 a=7xY41GCLvj8WFtek:21 a=QEXdDO2ut3YA:10 a=o72u2rHnfW5qNJ_4I8LD:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Op za 9 nov. 2019 om 23:53 schreef Finn Thain <fthain@telegraphics.com.au>:
> On Sat, 9 Nov 2019, Kars de Jong wrote:
> > diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
> > index ca8e3abeb2c7..4448567c495d 100644
> > --- a/drivers/scsi/zorro_esp.c
> > +++ b/drivers/scsi/zorro_esp.c
> > @@ -218,7 +218,7 @@ static int fastlane_esp_irq_pending(struct esp *esp)
> >  static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
> >                                       u32 dma_len)
> >  {
> > -     return dma_len > 0xFFFF ? 0xFFFF : dma_len;
> > +     return dma_len > (1U << 16) ? (1U << 16) : dma_len;
> >  }
> >
>
> Would it be safer to simply remove this code and leave
> esp_driver_ops.dma_length_limit == NULL for all board types?

I have considered that, but that version also imposes unneeded limits
on crossing a 24-bit address boundary. The Zorro boards don't seem to
need this.

Kind regards,

Kars.
