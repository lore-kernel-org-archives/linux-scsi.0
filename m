Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C44AC43141
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0417720724
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:06:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbfKNWGI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:06:08 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:51354 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbfKNWGI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 17:06:08 -0500
Received: from [212.54.42.137] (helo=smtp6.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iVNFd-0008W7-VQ; Thu, 14 Nov 2019 23:06:05 +0100
Received: from mail-wm1-f52.google.com ([209.85.128.52])
        by smtp6.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iVNFd-0001NH-RP; Thu, 14 Nov 2019 23:06:05 +0100
Received: by mail-wm1-f52.google.com with SMTP id z26so7533321wmi.4;
        Thu, 14 Nov 2019 14:06:05 -0800 (PST)
X-Gm-Message-State: APjAAAURyPhfOOx4Y2vj7PMQrQwRw3kYPCDhXW/6TEhptXZae/STW2qM
        w3Up/BWKlb64iDcHYo/NtutQ2KssGmRveBE/104=
X-Google-Smtp-Source: APXvYqwedyVj7E4qnRrqDg9R2/Pv6NMG7sPXh2C17xO2DZNjNaY1MhA89wKVcDDEd3B0lovX0AFfvpluQHqtVXfoh30=
X-Received: by 2002:a1c:453:: with SMTP id 80mr10908367wme.5.1573769165620;
 Thu, 14 Nov 2019 14:06:05 -0800 (PST)
MIME-Version: 1.0
References: <20191112185710.23988-1-jongk@linux-m68k.org> <20191114215956.21767-1-jongk@linux-m68k.org>
 <20191114215956.21767-2-jongk@linux-m68k.org>
In-Reply-To: <20191114215956.21767-2-jongk@linux-m68k.org>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Thu, 14 Nov 2019 23:06:27 +0100
X-Gmail-Original-Message-ID: <CACz-3rhHau0TCws=yLVi=3X15V2tvjsUXq9VyaDJwv=f=nL8Xw@mail.gmail.com>
Message-ID: <CACz-3rhHau0TCws=yLVi=3X15V2tvjsUXq9VyaDJwv=f=nL8Xw@mail.gmail.com>
Subject: Re: [PATCH 1/2] esp_scsi: Correct ordering of PCSCSI definition in
 esp_rev enum
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.128.52
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=WMwBoUkR c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=tBb2bbeoAAAA:8 a=R2T4xhTcrt1rEQjWB8EA:9 a=QEXdDO2ut3YA:10 a=win4SnVEMkUA:10 a=Oj-tNtZlA1e06AYgeCfH:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Oops, sorry, forgot to add v2 to the subject.

Op do 14 nov. 2019 om 23:00 schreef Kars de Jong <jongk@linux-m68k.org>:
...
