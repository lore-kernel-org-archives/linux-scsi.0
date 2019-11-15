Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65209C43141
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 07:04:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 402142075E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 07:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbfKOHEj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 02:04:39 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:42102 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726920AbfKOHEj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Nov 2019 02:04:39 -0500
Received: from [212.54.42.137] (helo=smtp6.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iVVen-0005p4-EP; Fri, 15 Nov 2019 08:04:37 +0100
Received: from mail-wm1-f46.google.com ([209.85.128.46])
        by smtp6.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iVVen-000867-AC; Fri, 15 Nov 2019 08:04:37 +0100
Received: by mail-wm1-f46.google.com with SMTP id c22so9132303wmd.1;
        Thu, 14 Nov 2019 23:04:37 -0800 (PST)
X-Gm-Message-State: APjAAAUxhsnhAEKucbu7hREyv5JLUl5eRH6nQ1hh9t2HoJAg5m/iBbtv
        eO5tBgisuLM8BLB0bDiAq42F55dd1cgp5xvq3vY=
X-Google-Smtp-Source: APXvYqy9yYCvJoDsJJkhuTJPbd10REfVaM8nknWq62Qf8xjpQgeVSKz99KrfGEC/CskbgAeg69ezkIDLHMFskEh4RS4=
X-Received: by 2002:a1c:453:: with SMTP id 80mr13120554wme.5.1573801477034;
 Thu, 14 Nov 2019 23:04:37 -0800 (PST)
MIME-Version: 1.0
References: <20191114215956.21767-1-jongk@linux-m68k.org> <20191114222518.2441-1-jongk@linux-m68k.org>
 <20191114222518.2441-2-jongk@linux-m68k.org> <alpine.LNX.2.21.1.1911151157150.9@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1.1911151157150.9@nippy.intranet>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Fri, 15 Nov 2019 08:04:56 +0100
X-Gmail-Original-Message-ID: <CACz-3rgjGkeH1tPR8mzoGaWySXepZZtzVJLxd=3rcz+TY-B1Hg@mail.gmail.com>
Message-ID: <CACz-3rgjGkeH1tPR8mzoGaWySXepZZtzVJLxd=3rcz+TY-B1Hg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] esp_scsi: Correct ordering of PCSCSI definition in
 esp_rev enum
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.128.46
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=WMwBoUkR c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=8981fWPbAAAA:8 a=CUAyi6wxMhN9au1ZHakA:9 a=QEXdDO2ut3YA:10 a=o72u2rHnfW5qNJ_4I8LD:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn!

Op vr 15 nov. 2019 om 03:13 schreef Finn Thain <fthain@telegraphics.com.au>:
> For simplicity, the entire patch series would normally show the same
> version number (v3).

OK, thanks.

> Also, the series would normally be a thread unto itself, rather than a sub-thread.

OK, I followed an example from the git-send-email manual ("which
avoids breaking threads to provide a new patch series").
I found the relevant convention in "Submitting patches", I didn't
notice that before. Thanks.

> ...
>
> This is Hannes' code so I'll leave it up to him to review this change.
>
> I presume this is untested on PCSCSI hardware. ISTR that there's an
> emulator for that board somewhere...

Yes, I don't have any, so I could not test it. QEMU emulates it, but
it doesn't care about CONFIG3 etc. at all.

Thanks for your reviews!

Kind regards,

Kars.
