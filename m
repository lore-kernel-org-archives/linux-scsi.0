Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 497B1C17441
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 09:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DC962196E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 09:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbfKLJem (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 04:34:42 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:48802 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725899AbfKLJem (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 04:34:42 -0500
Received: from [212.54.42.137] (helo=smtp6.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUSZL-0004OE-LD; Tue, 12 Nov 2019 10:34:39 +0100
Received: from mail-wm1-f44.google.com ([209.85.128.44])
        by smtp6.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUSZL-00073o-GZ; Tue, 12 Nov 2019 10:34:39 +0100
Received: by mail-wm1-f44.google.com with SMTP id t26so2140487wmi.4;
        Tue, 12 Nov 2019 01:34:39 -0800 (PST)
X-Gm-Message-State: APjAAAWPl1M6P3Ho1wxbFoRTuSoOncpry6Mv+sGamUe8Hj+IcfoDEFJv
        VGbeRvkz9debmcKKtVaFdwUDmSAVd1M3Zfouono=
X-Google-Smtp-Source: APXvYqzdttmBjRlX1gAWVSosaygJJWgRFNozXjRXYPOGlvyv5xsLCvnbLoHljnkAnbGSASAQxrEcuoDngPBviisl+ZA=
X-Received: by 2002:a1c:720b:: with SMTP id n11mr2774106wmc.60.1573551279260;
 Tue, 12 Nov 2019 01:34:39 -0800 (PST)
MIME-Version: 1.0
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
 <20191109191400.8999-1-jongk@linux-m68k.org> <1573330351.3650.4.camel@linux.ibm.com>
 <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
In-Reply-To: <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Tue, 12 Nov 2019 10:34:28 +0100
X-Gmail-Original-Message-ID: <CACz-3rgkdiFxTPd9gJ6Sebmuv7gG23wgZ6v9Fx4p_xg-_emr_g@mail.gmail.com>
Message-ID: <CACz-3rgkdiFxTPd9gJ6Sebmuv7gG23wgZ6v9Fx4p_xg-_emr_g@mail.gmail.com>
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.128.44
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=WMwBoUkR c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=pGLkceISAAAA:8 a=1UFXjjYtAAAA:8 a=G3ydgQW_W0eQeUwnF44A:9 a=QEXdDO2ut3YA:10 a=vgRaD6Luq-vJqV3RfsKp:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

Op zo 10 nov. 2019 om 03:36 schreef Michael Schmitz <schmitzmic@gmail.com>:
> I need to confirm this from a data book of the older (pre-fast)
> revisions of this chip family. but since as Kars also states, the core
> driver default for the 16 bit transfer size is 64k as well, I very much
> suspect the same behaviour for the older revisions.

According to ftp://bitsavers.informatik.uni-stuttgart.de/components/ncr/scsi/NCR53C90ab.pdf,
on the NCR 53C90A programming the transfer counter to 0 also means
64k. That's the oldest data book I could find.
But the Zorro driver assumes a fast variant of the chip anyway (the
clock frequency is hard coded to 40 MHz), so this point is a little
moot.

Kind regards,

Kars.
