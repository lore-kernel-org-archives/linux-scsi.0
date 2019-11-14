Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEDB4C43215
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:07:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8A5720718
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 22:07:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfKNWHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 17:07:13 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:51844 "EHLO
        smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726767AbfKNWHN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Nov 2019 17:07:13 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq3.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iVNGh-0000KH-5a; Thu, 14 Nov 2019 23:07:11 +0100
Received: from mail-wr1-f49.google.com ([209.85.221.49])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iVNGh-0007mt-1i; Thu, 14 Nov 2019 23:07:11 +0100
Received: by mail-wr1-f49.google.com with SMTP id b18so7128649wrj.8;
        Thu, 14 Nov 2019 14:07:10 -0800 (PST)
X-Gm-Message-State: APjAAAWIbjqduR6wfRfJfop5RHBBUFojSVqI53sDnvIX7PuKWNMdEXCo
        I3dcnZ0koB2WQkQR4UOmM7IT6O6SLDElcubvdwo=
X-Google-Smtp-Source: APXvYqy4kIbEc7Zv8VGYtyuJaS88BH0TSsA3R4gJ3OFkY6KPpQtCKRaBvGk8yRzkDGA09k31zu1qWoJw9P+UKoq+kAk=
X-Received: by 2002:adf:ea8d:: with SMTP id s13mr11286146wrm.366.1573769230837;
 Thu, 14 Nov 2019 14:07:10 -0800 (PST)
MIME-Version: 1.0
References: <20191112185710.23988-1-jongk@linux-m68k.org> <20191114215956.21767-1-jongk@linux-m68k.org>
 <20191114215956.21767-3-jongk@linux-m68k.org>
In-Reply-To: <20191114215956.21767-3-jongk@linux-m68k.org>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Thu, 14 Nov 2019 23:07:32 +0100
X-Gmail-Original-Message-ID: <CACz-3riLONu=0PUHAu9RpGzdj8AVGwHrC9wEv1bczo=hu7SZLA@mail.gmail.com>
Message-ID: <CACz-3riLONu=0PUHAu9RpGzdj8AVGwHrC9wEv1bczo=hu7SZLA@mail.gmail.com>
Subject: Re: [PATCH 2/2] esp_scsi: Add support for FSC chip
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        schmitzmic@gmail.com, fthain@telegraphics.com.au
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.49
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=tBb2bbeoAAAA:8 a=lsysnil6fbZx636Eg1UA:9 a=QEXdDO2ut3YA:10 a=win4SnVEMkUA:10 a=Oj-tNtZlA1e06AYgeCfH:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bah, ignore this... it still has a merge conflict.

Sorry.

Op do 14 nov. 2019 om 23:00 schreef Kars de Jong <jongk@linux-m68k.org>:
