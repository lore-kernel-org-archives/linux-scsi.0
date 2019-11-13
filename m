Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 587ACC17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 15:04:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FC482245C
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 15:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfKMPEJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 10:04:09 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:44554 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726812AbfKMPEJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 10:04:09 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUuBj-0005AH-3U; Wed, 13 Nov 2019 16:04:07 +0100
Received: from mail-wr1-f52.google.com ([209.85.221.52])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iUuBi-00064K-Vk; Wed, 13 Nov 2019 16:04:07 +0100
Received: by mail-wr1-f52.google.com with SMTP id s5so2766439wrw.2;
        Wed, 13 Nov 2019 07:04:06 -0800 (PST)
X-Gm-Message-State: APjAAAXi1kptu7LeqB/3y2k6RHxBhv8Y1YYujTgr96D8gg+8K4F7yWiO
        +61mSTZMmplwQ1Sz47V0K0G19gtSqGm7EnNe16I=
X-Google-Smtp-Source: APXvYqz/w4ljt9buLhiVQ18ue9qf21x4K4kKqNT+JKY0tOyba9PHSWbZr9CuWIhRLyWWJLpcZTrBbskm2GW4BsiUjnA=
X-Received: by 2002:a5d:44d2:: with SMTP id z18mr3140767wrr.209.1573657446722;
 Wed, 13 Nov 2019 07:04:06 -0800 (PST)
MIME-Version: 1.0
References: <20191029220503.7553-1-jongk@linux-m68k.org> <20191112185710.23988-1-jongk@linux-m68k.org>
 <20191112185710.23988-2-jongk@linux-m68k.org> <20191113142208.GA8269@infradead.org>
In-Reply-To: <20191113142208.GA8269@infradead.org>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Wed, 13 Nov 2019 16:03:55 +0100
X-Gmail-Original-Message-ID: <CACz-3rg5vNXCZQszMccSJikbZgBmdyPOMC+vvs3QuuhrQGW_MA@mail.gmail.com>
Message-ID: <CACz-3rg5vNXCZQszMccSJikbZgBmdyPOMC+vvs3QuuhrQGW_MA@mail.gmail.com>
Subject: Re: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in
 esp_rev enum
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com,
        fthain@telegraphics.com.au
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.52
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=JfrnYn6hAAAA:8 a=l8ZAoXzOCdwS2lX8vb4A:9 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Christoph!

Op wo 13 nov. 2019 om 15:22 schreef Christoph Hellwig <hch@infradead.org>:
>
> On Tue, Nov 12, 2019 at 07:57:09PM +0100, Kars de Jong wrote:
> > The order of the definitions in the esp_rev enum is important. The values
> > are used in comparisons for chip features.
>
> Yikes.  Wouldn't it make much more sense to have a feature bitmap?

Yes, I mentioned that in my cover letter already, and it was discussed
a bit on the Linux/m68k mailing list.
 It may be hard to get that tested though, most of the users are
legacy architectures with a probably very limited number of users.
But if a mostly review-based process is good enough, I am certainly
willing to change it.

Kind regards,

Kars.
