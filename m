Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5837C11F67
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 12:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 995B06128D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 12:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhGMMsm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 08:48:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236146AbhGMMsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Jul 2021 08:48:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9243611AB;
        Tue, 13 Jul 2021 12:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626180351;
        bh=FVR1cfoVz4ZTVgihL/TBDgLD2SOeoQiWYsaGuF2lpT0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LsIUGIruXxEHgiRGWHytHSewI2yd9si9rgfkqm6BILyZFnLo8d6vvodgXPsRtCXn7
         0k1F76FYwIwZXW7TlXrWdnMBybD1QVAK1cvNmshShm0nW/dy7hEtqp9TdcZkIX33E6
         RwjtWTUlmYX6BEPbwOZQPCA+Tjm86Dio7n7Bma2aAqGQab+jhcetoUqqV49A0xmxZ6
         Kl86WkRKa3yzHdaccayiSn86286hGk9Ar3PI8oRovWLshKc2s8pbyYmceXhkd591gy
         8I2Q8hFxndb8O5/H5RVO7HHsMbITmAnColQfSsSp2rKBfYkKe0Rh82wne+pFmGuakz
         2BArl+3fWla0w==
Received: by mail-pg1-f171.google.com with SMTP id s18so21510938pgg.8;
        Tue, 13 Jul 2021 05:45:51 -0700 (PDT)
X-Gm-Message-State: AOAM53057GtauII7l74fnq23vMnBr7Pfp8OqfZsJoKo8sotTJekQP/BF
        czFq3DbatTXOS1LkKuJ1ZuMNSwteCvu5dsJL+Xo=
X-Google-Smtp-Source: ABdhPJwGEYoM2NLAxWeYb+0E+kIrwhFFrXS50V3nh4QAre2PJh2JC6W1CxIABdvxwyy5oHbGbu8XZYDmAVOxT6QtBq4=
X-Received: by 2002:a65:4103:: with SMTP id w3mr4187454pgp.308.1626180351585;
 Tue, 13 Jul 2021 05:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200613030454epcas5p400f76485ddb34ce6293f0c8fa94332b8@epcas5p4.samsung.com>
 <20200613024706.27975-1-alim.akhtar@samsung.com> <20200613024706.27975-9-alim.akhtar@samsung.com>
 <CAGOxZ500JD5xNWb0xFyEgaUH0qwQKm+kn1Ng71_1SM1wmJFxKg@mail.gmail.com>
In-Reply-To: <CAGOxZ500JD5xNWb0xFyEgaUH0qwQKm+kn1Ng71_1SM1wmJFxKg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Tue, 13 Jul 2021 14:45:39 +0200
X-Gmail-Original-Message-ID: <CAJKOXPd6VMBaW7zBDXb7tXDHr3xwV2yZXxZtLJqNe3T69oUqsw@mail.gmail.com>
Message-ID: <CAJKOXPd6VMBaW7zBDXb7tXDHr3xwV2yZXxZtLJqNe3T69oUqsw@mail.gmail.com>
Subject: Re: [RESEND PATCH v10 08/10] dt-bindings: ufs: Add bindings for
 Samsung ufs host
To:     Alim Akhtar <alim.akhtar@gmail.com>,
        Chanho Park <chanho61.park@samsung.com>
Cc:     Alim Akhtar <alim.akhtar@samsung.com>, robh@kernel.org,
        devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kishon@ti.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 13 Jul 2021 at 14:36, Alim Akhtar <alim.akhtar@gmail.com> wrote:
>
> Hi Rob
> Anything else needs to be done for this patch?
>
> On Sat, Jun 13, 2020 at 8:36 AM Alim Akhtar <alim.akhtar@samsung.com> wrote:
> >
> > This patch adds DT bindings for Samsung ufs hci
> >
> > Reviewed-by: Rob Herring <robh@kernel.org>
> > Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>

It has Rob's ack, so it can be taken directly via SCSI tree.

Chanho,
I guess here is the answer why exynos7-ufs compatible was not
documented, so you can build on top of it.

Best regards,
Krzysztof
