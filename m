Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA560CCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 08:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiGKIpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 04:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiGKIpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 04:45:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FD1C3;
        Mon, 11 Jul 2022 01:45:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01BCCB80E72;
        Mon, 11 Jul 2022 08:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9652C34115;
        Mon, 11 Jul 2022 08:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657529140;
        bh=QtxIhf0k2gio15daq8OVYJQBXBIa6NCxYKJrxnYcFFc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=oIRAYTlC/Yc2oiOESJQJLhT6f2aT+iDf/mH//oNAdLjmQucEpupAAaDT4tfVIs+lJ
         WBcSKl5dUJ3/9jc57NIJqveMHvjOZEN6hoyOp1fMiVSZ6EdQhzDcAnmUK+sbTKNwPD
         uqcMzogcUmflkqsnWbnsNlTvBWSWtDV5tqKZiQ2eD0TLR08O8/crAmMSS6pzE19Wrc
         +DdT1sAb1GAJ4aHSjnfrBLL7hmtnvr6FL/2JealCebezFqrrCbbq1VNU3j2IQShfwH
         tcEiT5q/NGe7c5PBPNb+rXY6mFzrmKGcyyF3fl+h3Dtev/cXaxRc+7Sp4GPsImBdI3
         IourEKWrquzaA==
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-31c9b70c382so41812517b3.6;
        Mon, 11 Jul 2022 01:45:40 -0700 (PDT)
X-Gm-Message-State: AJIora9LZ47WWF5QGix224DHJkI8p+AFbZoUkPrgUjA+/5FwUlNB7B41
        LZWRErOJLqqCX28KwTm/gReB0K7A/X4b1ZAecIw=
X-Google-Smtp-Source: AGRyM1sUsXiG43gYdPyrOaU2lgN3ybvaac4dSWJPgrZcyz6wz3Jnrh2yYyISG/nxqMSKRmWAMQMlR+k8yV4FuLMnIWI=
X-Received: by 2002:a81:1e4d:0:b0:31c:86f1:95b1 with SMTP id
 e74-20020a811e4d000000b0031c86f195b1mr17602482ywe.42.1657529139765; Mon, 11
 Jul 2022 01:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220709001019.11149-1-schmitzmic@gmail.com> <20220709001019.11149-2-schmitzmic@gmail.com>
 <CAK8P3a2kwg56-UTv275GJ1r_SDsfoX2fMcmXrvNURN+L3UHoSA@mail.gmail.com> <89f0efa9-9626-2380-49dc-432ac04fe6f2@gmail.com>
In-Reply-To: <89f0efa9-9626-2380-49dc-432ac04fe6f2@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 11 Jul 2022 10:45:23 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0JRhKj9aoS3-RKsu3yGW+0geSB7CqEytdbBn622nREFw@mail.gmail.com>
Message-ID: <CAK8P3a0JRhKj9aoS3-RKsu3yGW+0geSB7CqEytdbBn622nREFw@mail.gmail.com>
Subject: Re: [PATCH v1 1/4] m68k - add MVME147 SCSI base address to mvme147hw.h
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     "Linux/m68k" <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 11, 2022 at 6:16 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> Am 11.07.2022 um 04:06 schrieb Arnd Bergmann:
> > On Sat, Jul 9, 2022 at 2:10 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
> > I think this should be an 'void *__iomem' token, not a plain integer.
> > Apparently the driver internally uses a 'volatile void *', but some of
> > the other front-ends are already converted to use __iomem.
>
> I'll pass the base address through a platform data struct in the next
> version to address your other concerns. Haven't seen __iomem types used
> in the other drivers - two are Zorro devices, and two platform devices
> (a3000 and sgiwd93). Found no other wd33c93 drivers...

Right, I noticed this as well. The ideal way to do this would be to change
all of these files to use __iomem tokens consistently, and then use
ioread32be()/iowrite32be() in place of the volatile pointer dereference.

Maybe leave that for a follow-up series, you'll probably uncover
more of these issues once you take that step.

       Arnd
