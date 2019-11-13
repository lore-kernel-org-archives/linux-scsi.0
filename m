Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707D0C17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 09:30:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53D4922459
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 09:30:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKMJaW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 04:30:22 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:41640 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbfKMJaW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 04:30:22 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUoyg-0005Jo-82; Wed, 13 Nov 2019 10:30:18 +0100
Received: from mail-wr1-f49.google.com ([209.85.221.49])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUoyg-0006DW-4A; Wed, 13 Nov 2019 10:30:18 +0100
Received: by mail-wr1-f49.google.com with SMTP id n1so1458549wra.10;
        Wed, 13 Nov 2019 01:30:18 -0800 (PST)
X-Gm-Message-State: APjAAAUT7MW5nZw7kFmTlgJV+9a/Kt0qlm2OMmI45cLGtNFQcOwky7s4
        RExJGQzFtrjv3AuC+/0j7mKTfNBPBX0aYatqVrA=
X-Google-Smtp-Source: APXvYqxtA6Ix/hxUo+R0qYpuGFiNpdq2j2kYAiHjwtHRtyhSMuzyAHvDeA1uUEoiwTsfjwGOrqia1CDDJhD7YxxtqDA=
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr1836387wrm.366.1573637417871;
 Wed, 13 Nov 2019 01:30:17 -0800 (PST)
MIME-Version: 1.0
References: <20191029220503.7553-1-jongk@linux-m68k.org> <20191112185710.23988-1-jongk@linux-m68k.org>
 <20191112185710.23988-3-jongk@linux-m68k.org> <alpine.LNX.2.21.1.1911131007110.13@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1.1911131007110.13@nippy.intranet>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Wed, 13 Nov 2019 10:30:06 +0100
X-Gmail-Original-Message-ID: <CACz-3rhP9pfg4tVe5GikX-7MWC2sGtE0AsoPeuUBR-a07YxQFA@mail.gmail.com>
Message-ID: <CACz-3rhP9pfg4tVe5GikX-7MWC2sGtE0AsoPeuUBR-a07YxQFA@mail.gmail.com>
Subject: Re: [PATCH 2/2] esp_scsi: Add support for FSC chip
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.49
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=8981fWPbAAAA:8 a=5gkSXQyuQpC8iqEFKKcA:9 a=QEXdDO2ut3YA:10 a=o72u2rHnfW5qNJ_4I8LD:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Thanks for your review!

Op wo 13 nov. 2019 om 00:18 schreef Finn Thain <fthain@telegraphics.com.au>:
>
> On Tue, 12 Nov 2019, Kars de Jong wrote:
> > +#define ESP_UID_REV           0x07     /* ESP revision bitmask */
>
> This is unused.

Yes, but it was already there, I just moved it. I prefer to leave it
in, since it describes the register layout.

> > +#define ESP_UID_FAM           0xf8     /* ESP family bitmask */
> > +
> > +#define ESP_FAMILY(uid) (((uid) & ESP_UID_FAM) >> 3)
> > +
>
> The ESP_UID_FAM symbol only appears here. I don't think it adds value.

OK, I can just change the macro to:

#define ESP_FAMILY(uid) (((uid) & 0xf8) >> 3)

> > +/* Values for the ESP family */
>
> I would omit that comment.

I will change it to "Values for the ESP family bits" as you suggested
in the next mail.

> >  #define ESP_UID_F100A         0x00     /* ESP FAS100A  */
> >  #define ESP_UID_F236          0x02     /* ESP FAS236   */
> > -#define ESP_UID_REV           0x07     /* ESP revision */
> > -#define ESP_UID_FAM           0xf8     /* ESP family   */
> > +#define ESP_UID_HME           0x0a     /* FAS HME      */
> > +#define ESP_UID_FSC           0x14     /* NCR/Symbios Logic FSC */
> >
>
> Is there a distinction between the chip's uid and the chip's family?

Yes, the complete UID also includes the revision. The old driver had
cases where the family code was the same but the revision was
different.

Kind regards,

Kars.
