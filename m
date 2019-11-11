Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701D0C17441
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 08:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 481F22084F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 08:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfKKIrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Nov 2019 03:47:23 -0500
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:33998 "EHLO
        smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbfKKIrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Nov 2019 03:47:23 -0500
Received: from [212.54.42.137] (helo=smtp6.tb.mail.iss.as9143.net)
        by smtpq4.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iU5M1-0001mH-3w; Mon, 11 Nov 2019 09:47:21 +0100
Received: from mail-wr1-f45.google.com ([209.85.221.45])
        by smtp6.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iU5M0-0001uS-W9; Mon, 11 Nov 2019 09:47:21 +0100
Received: by mail-wr1-f45.google.com with SMTP id z10so8316903wrs.12;
        Mon, 11 Nov 2019 00:47:20 -0800 (PST)
X-Gm-Message-State: APjAAAVdkduD1YyplcDfELa+cQEQJ4THU49SR+rkwsevBTlZZn5dOknh
        zxsh1WrQkB7G2O62jHIJaAYCOlCRPxIbdhNg1Bo=
X-Google-Smtp-Source: APXvYqxytncLcfi7aeYlcB1IxU7tMFvoLFaFecX1/Na+heYEi6TijmtyvmgPz9vDvICRH+4e7UxekGqVxzWn/OJPiJE=
X-Received: by 2002:a5d:4146:: with SMTP id c6mr18862537wrq.250.1573462040680;
 Mon, 11 Nov 2019 00:47:20 -0800 (PST)
MIME-Version: 1.0
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com>
 <20191109191400.8999-1-jongk@linux-m68k.org> <1573330351.3650.4.camel@linux.ibm.com>
 <6b914b12-cbc7-6fe6-7cba-3e89b2f6f19b@gmail.com> <CACz-3rjUh8tcShX5OPi+37JvF8PqG-8AEf5uMQHjMynSaVa1gw@mail.gmail.com>
 <8c356175-e490-68c0-6114-5192eedc3a4f@gmail.com>
In-Reply-To: <8c356175-e490-68c0-6114-5192eedc3a4f@gmail.com>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Mon, 11 Nov 2019 09:47:09 +0100
X-Gmail-Original-Message-ID: <CACz-3riZcAUEawL7BaDrVbzUh5VzsXmYSazRTju5_U=LhO6c3g@mail.gmail.com>
Message-ID: <CACz-3riZcAUEawL7BaDrVbzUh5VzsXmYSazRTju5_U=LhO6c3g@mail.gmail.com>
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     James Bottomley <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.45
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=WMwBoUkR c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=pGLkceISAAAA:8 a=xNf9USuDAAAA:8 a=hJ9ZtYj-RI1EAQISWCsA:9 a=EE2vHBecVcuu-u5a:21 a=SQQkrWvguoklZZ3D:21 a=QEXdDO2ut3YA:10 a=SEwjQc04WA-l_NiBhQ7s:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Michael,

Op zo 10 nov. 2019 om 20:26 schreef Michael Schmitz <schmitzmic@gmail.com>:
> >>> case for any of the cards the zorro_esp drives, it might be better to
> >>> lower the max length to 61440 (64k-4k) so the residual is a page.
> >> For the benefit of keeping the code simple, and avoid retesting the
> >> fastlane board, that might indeed be the better solution.
> >
> > But it's slower... :-P
> >
> I wonder what max. transfer size had been used so far, in the majority
> of cases. I hadn't observed this bug in my tests of the ESP driver on
> elgar. So it might not matter so much in practice.

Does Elgar indeed have a Blizzard 2060 as
https://wiki.debian.org/M68k/Autobuilder says?
If it does, it does surprise me that it works, since the DMA engine
appears to be very much like the one
of the Blizzard 1230 (including the >> 1 of the address).
Even when just loading bash on my system, there were many
65535-and-then-1 byte transfers.
It may of course depend on how fragmented your disk is.

> > Also, I may be adding another board-specific version for the Blizzard
> > 12x0 IV to enable 24-bit transfers, like the am53c974 driver does, in
> > a later patch.
>
> If we can differentiate between the Mark IV board and the Mark II board
> in a reliable way, fine. I can't remember whether I've had a report on
> that ever.

They have a different Zorro ID, so that should not be a problem.
By the way, do you remember why you chose to not use the full Zorro
IDs for the various SCSI boards asdefined in zorro_ids.h but only
the manufacturer defines?


Kind regards,

Kars.
