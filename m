Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F7AC17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 08:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE333222D0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 08:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfKMIBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 03:01:00 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:51324 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725996AbfKMIBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 03:01:00 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUnaD-0001lL-9q; Wed, 13 Nov 2019 09:00:57 +0100
Received: from mail-wm1-f54.google.com ([209.85.128.54])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUnaD-0001R2-5g; Wed, 13 Nov 2019 09:00:57 +0100
Received: by mail-wm1-f54.google.com with SMTP id f3so874403wmc.5;
        Wed, 13 Nov 2019 00:00:57 -0800 (PST)
X-Gm-Message-State: APjAAAUQ8CAwphUNvS77OGtDsA78wRkKONHa4P8LD+yh7un5mO0drXoU
        y6DS/D6jPU+E/v2zwLRbs4L/HxgLKEsUBg1sEa4=
X-Google-Smtp-Source: APXvYqxMhw+PeGdjj5M0GDOk1bCpolr5G5nV3qn6IQYxmHmW303SVxxwJmTj/1msYDy6LAywOnebHPtBoaCRo6qg948=
X-Received: by 2002:a05:600c:c3:: with SMTP id u3mr1350271wmm.35.1573632056846;
 Wed, 13 Nov 2019 00:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20191029220503.7553-1-jongk@linux-m68k.org> <20191112185710.23988-1-jongk@linux-m68k.org>
 <20191112185710.23988-2-jongk@linux-m68k.org> <alpine.LNX.2.21.1.1911130946410.13@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1.1911130946410.13@nippy.intranet>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Wed, 13 Nov 2019 09:00:45 +0100
X-Gmail-Original-Message-ID: <CACz-3rhWQgCXXCXcd-=+r09+WOPLs3FrcqcdYd3g=dYrci=ucw@mail.gmail.com>
Message-ID: <CACz-3rhWQgCXXCXcd-=+r09+WOPLs3FrcqcdYd3g=dYrci=ucw@mail.gmail.com>
Subject: Re: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in
 esp_rev enum
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.128.54
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=8981fWPbAAAA:8 a=pX--W2Stih7kB7ROB2sA:9 a=QEXdDO2ut3YA:10 a=o72u2rHnfW5qNJ_4I8LD:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Thanks for your review!

Op wo 13 nov. 2019 om 00:07 schreef Finn Thain <fthain@telegraphics.com.au>:
> On Tue, 12 Nov 2019, Kars de Jong wrote:
> > Finally, move the PCSCSI definition to the right place in the enum. In its
> > previous location, at the end of the enum, the wrong values are written to
> > the CONFIG3 register when used with FAST-SCSI targets. Add comments to the
> > enum explaining this.
> >
> >  enum esp_rev {
> > -     ESP100     = 0x00,  /* NCR53C90 - very broken */
> > -     ESP100A    = 0x01,  /* NCR53C90A */
> > -     ESP236     = 0x02,
> > -     FAS236     = 0x03,
> > -     FAS100A    = 0x04,
> > -     FAST       = 0x05,
> > -     FASHME     = 0x06,
> > -     PCSCSI     = 0x07,  /* AM53c974 */
> > +     ESP100,  /* NCR53C90 - very broken */
> > +     ESP100A, /* NCR53C90A */
> > +     ESP236,
> > +     /* Chips below this line use ESP_CONFIG3_FSCSI to enable FAST SCSI */
> > +     FAS236,
> > +     PCSCSI,  /* AM53c974 */
> > +     /* Chips below this line use ESP_CONFIG3_FAST to enable FAST SCSI */
> > +     FAS100A,
> > +     FAST,
> > +     FASHME,
> >  };
> >
> >  struct esp_cmd_entry {
> >
>
> FAS100A, FAST and FASHME are below both lines, which is a bit confusing.

Hmm, you're right. But I don't really know how to solve that. But if
you think the initial comment is enough to trigger people to
investigate the algorithm, I can remove them.

> In general, I don't like to see comments that merely re-state the explicit
> logic in the algorithm. Such comments add no value.
>
> (At best this redundancy creates a maintenance burden and at worst the
> commentary becomes neglected until it creates contradictions.)

Unfortunately the algorithm isn't very obvious here (well, not to me at least).

Kind regards,

Kars.
