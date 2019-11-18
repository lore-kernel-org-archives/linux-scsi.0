Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D70C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 533E120855
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 13:27:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfKRN1x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 08:27:53 -0500
Received: from smtpq4.tb.mail.iss.as9143.net ([212.54.42.167]:42798 "EHLO
        smtpq4.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726284AbfKRN1x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 08:27:53 -0500
Received: from [212.54.42.110] (helo=smtp7.tb.mail.iss.as9143.net)
        by smtpq4.tb.mail.iss.as9143.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iWh4J-0001NH-TA; Mon, 18 Nov 2019 14:27:51 +0100
Received: from mail-wr1-f46.google.com ([209.85.221.46])
        by smtp7.tb.mail.iss.as9143.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <jongk@linux-m68k.org>)
        id 1iWh4J-0004tQ-Ok; Mon, 18 Nov 2019 14:27:51 +0100
Received: by mail-wr1-f46.google.com with SMTP id i12so19480992wro.5;
        Mon, 18 Nov 2019 05:27:51 -0800 (PST)
X-Gm-Message-State: APjAAAXZmfW6OajiuzpYYJWS3DzkQqWvJJbVLsTuob6cqw+daLBfFtwz
        qa7vBXo2fv+svkaHp4Oion5gIUNxPgjkjypDLMI=
X-Google-Smtp-Source: APXvYqw7WMp0wWz0+U3gAPLJ3Fu9KAqqkBh2u2i2BKxP+wUYRI/5cMl7EzjcQf7cmnE+WcptNtu/Dvw9MQsWQtvsCXM=
X-Received: by 2002:a05:6000:14a:: with SMTP id r10mr19311305wrx.310.1574083671481;
 Mon, 18 Nov 2019 05:27:51 -0800 (PST)
MIME-Version: 1.0
References: <20191114215956.21767-1-jongk@linux-m68k.org> <20191114222518.2441-1-jongk@linux-m68k.org>
 <20191114222518.2441-3-jongk@linux-m68k.org> <alpine.LNX.2.21.1.1911151212001.9@nippy.intranet>
In-Reply-To: <alpine.LNX.2.21.1.1911151212001.9@nippy.intranet>
From:   Kars de Jong <jongk@linux-m68k.org>
Date:   Mon, 18 Nov 2019 14:27:40 +0100
X-Gmail-Original-Message-ID: <CACz-3rgx4ftrm0JaBq=X13x_3YdcT5zfjcAq0KZtR+hT6CHmow@mail.gmail.com>
Message-ID: <CACz-3rgx4ftrm0JaBq=X13x_3YdcT5zfjcAq0KZtR+hT6CHmow@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] esp_scsi: Add support for FSC chip
To:     Finn Thain <fthain@telegraphics.com.au>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org,
        linux-m68k@vger.kernel.org, schmitzmic@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-SourceIP: 209.85.221.46
X-Authenticated-Sender: karsdejong@home.nl (via SMTP)
X-Ziggo-spambar: /
X-Ziggo-spamscore: 0.0
X-Ziggo-spamreport: CMAE Analysis: v=2.3 cv=cPSeTWWN c=1 sm=1 tr=0 a=9+rZDBEiDlHhcck0kWbJtElFXBc=:19 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=IkcTkHD0fZMA:10 a=MeAgGD-zjQ4A:10 a=8981fWPbAAAA:8 a=tBb2bbeoAAAA:8 a=E4AfsrIfWqNCM_Q_kVwA:9 a=QEXdDO2ut3YA:10 a=o72u2rHnfW5qNJ_4I8LD:22 a=Oj-tNtZlA1e06AYgeCfH:22
X-Ziggo-Spam-Status: No
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Finn,

Thanks again for the review!

Op vr 15 nov. 2019 om 03:09 schreef Finn Thain <fthain@telegraphics.com.au>:
> On Thu, 14 Nov 2019, Kars de Jong wrote:
>
> > The FSC (NCR53CF9x-2 / SYM53CF9x-2) has a different family code than QLogic
> > or Emulex parts. This caused it to be detected as a FAS100A.
> >
> > Unforunately, this meant the configuration of the CONFIG3 register was
> > incorrect. This causes data transfer issues with FAST-SCSI targets.
> >
> > The FSC also has the CONFIG4 register. It can be used to enable a feature
> > called Active Negation which should always be enabled according to the data
> > manual.
> >
> > Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
>
> Reviewed-by: Finn Thain <fthain@telegraphics.com.au>
>
> This is not the best scope for this variable. You have to touch both lines
> (declaration and initialization) anyway, so you can easily improve this.

Good point, I will move it to inside the  "if (esp->rev) == FAST) {" block.

> > -             /* Fast 236, AM53c974 or HME */
> > +     case FSC:
> > +             /* Fast 236, AM53c974, FSC or HME */
>
> This comment merely re-states the logic in the case labels. If you don't
> delete the comment, it has to be maintained along with the case labels.
> Consequently this patch is longer than it needs to be.

Yes, I agree. I'll remove the comment.

>
> You've added "(FSC)" and "(am53c974)" here, which is fine but you've
> repeated yourself in the comment, "found on am53c974 and FSC chips". The
> DRY principle applies here too (Don't Repeat Yourself).

I'll also remove that comment.

> > @@ -264,6 +271,7 @@ enum esp_rev {
> >       ESP236,
> >       FAS236,
> >       PCSCSI,  /* AM53c974 */
> > +     FSC,     /* NCR/Symbios Logic FSC */
>
> Is there a difference between "FSC" and "NCR/Symbios Logic FSC"?

No, the respective data manuals all name these variants as "FSC".

> The reader has to infer that not all "FSC" chips are equivalent and that the
> brand name is significant. Whereas, there is real value in putting a part
> code here (as in the line above).

Agreed, I'll add the part code instead.

Kind regards,

Kars.
