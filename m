Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC8AC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 07:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8BCA60FC0
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Sep 2021 07:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232042AbhILHoG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 03:44:06 -0400
Received: from mout.web.de ([212.227.17.11]:56227 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhILHoG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Sep 2021 03:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1631432561;
        bh=iu4rfBlz1a1Ad4kydnOedMvxd6DfnJ3VX/NZo+UT6lk=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=SCBBLquDLFa1HW7hQOsfsOFw+QXjFkTyeubAjctXYE3v95D/23rxbHzPRxvifQJBg
         Z48nM9ccCI2mBcBmd0Zn1I5onYi2uRJ6X2dxq439pyEiTWIerz5Bj8ubboGZhHyWoC
         qtEL9ySD2uhkjnmMpjLvERJF1Qden1SmDilPu6oQ=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from localhost.localdomain ([95.91.197.142]) by smtp.web.de
 (mrweb102 [213.165.67.124]) with ESMTPSA (Nemesis) id
 0MQNiS-1mUqQH2nue-00TpMN; Sun, 12 Sep 2021 09:42:41 +0200
Date:   Sun, 12 Sep 2021 09:42:39 +0200
From:   Ali Akcaagac <aliakc@web.de>
To:     Finn Thain <fthain@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Jamie Lenehan" <lenehan@twibble.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove obsolete e-mail addresses
Message-ID: <20210912094239.2fe068ed@web.de>
In-Reply-To: <c9168d8e5595bdaa3a18d596f781b55e052af3fc.1631158421.git.fthain@linux-m68k.org>
References: <c9168d8e5595bdaa3a18d596f781b55e052af3fc.1631158421.git.fthain@linux-m68k.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:nlw6XZfe/HexeDc3X2VRFqYszTsCV4vq3Z3fMRmD0iD0YQOt3mL
 YSdF0QhAG5on/r4ZPdlAdv1nED67Bm35k99BrbPzav5uO+0O/YKY1dbYnJT86+MdRbSDdBb
 WmkyDU49/S7sSsH+zGQ5K4+iA0K4OcS8KT/Y8d2Me9QyHXhk2Tk91E3wk5E6SJ60+dtoEUf
 I8SmpW0Q6dDj5zLyciOgg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:2+HdjXOPBA4=:OAE1euhrGLzglMIUHPmMUr
 QZh9oL+dTPNmlzLatEu2K+3WO1tHn8CLXZVeO4HD+EFdXmL6SsN1GU1kb2oxG4FJzGLXueqiZ
 tifDIf2nq0P8UxHXVAYjrNm5WovW5fpYD0ChetyLuD+sIUlofl1ab20YrKHHQM9Wq1EXJGNie
 4bLcK+sYAG1RyrLwa9Wj7KANzYlXeFwI0cYQTbXHMGAWFWtTXA466wszxzaKOUJvSGtECHBA7
 iC9D7GmxqiRV6SJ1FvApkW60eKLe4+NO5E6Z9EvW7NTO4PGsji5BJx9PALvpwHkujPOSPkonQ
 to5IkYXiWp3wdJKkKg3P5euywk7/K21Yc44YtITfYmoMqLr1BbsU5LwUm0AtEjyhP83XK9Rw+
 uv40pIH+2V09696qIL2X5vYnzRTloUER3tam6RO94m9HBbCgA3ahleQOpRCv6UyWpatpq4WiA
 IP93vMKQpVBt/bv9ndI3VVYHrOgPfgiwFvB1dHuwUs7FLY+pS5/MTA1v341cf6Mmv4VzLIXqx
 gfcEacCEsMlSsMjCTq7Mq+yMqmnvqB3EHqgidHxyzCN3/GuA8Z62hbYSVsopFBgVYYirlWiI7
 8QzhKvEFKCburpQAZgg/M3/OaNJbicmy2ZJ2KRk3G6KOgDUSOdeQcQMUGYOZaFbDw99nSsm/Z
 5l09dNRTCvSypipSp3m1wkUlDeatAg6OkRaBS9JYUMqHcwy+S5Hw6cnvLbxg2IX4IAH2o0Q5+
 yzyBt9a200WrZaj9xx0I3p0bb94FfALQ1J0gtIkKsYZaHHfYA+ON8IYVv9iXwfJ19ZKmpPV2C
 Lo2HsUGqZEnADBpqAmGQ3F5sFbtVPKEeGwsIF7/eHuenF9+PoAKKa8ocr6nrY98mtynWIObi5
 1Kv2535ctlxJbPK6HA0RjOA3yIf0tY8jL0ZwyEjIxZfMEGU8PcSpn7JgBDVxs3rVTSocBkkUT
 WOUWnN/nS52NyD16njRwqLivCvVSi6VqpfBNxZ7cf1EfNQ4bKXY7fXriAfpOl3tH0AiChTFrA
 +MbLardzb5cU+ie3hr9ohHDn12vodncBhfoqD2XHDP6Mhd16vTp45jvIWbrbdk9BBS1CWHD95
 5svD5ikpWCY5B0=
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

sorry for not responding earlier. I've just started a new job at a
different location and things are a bit messy right now. The patch
looks good, considering for an old SCSI driver that probably isn't
existing anymore :)

Cheers

Ali

On Thu, 09 Sep 2021 13:33:41 +1000
Finn Thain <fthain@linux-m68k.org> wrote:

> These e-mail addresses bounced.
>
> Signed-off-by: Finn Thain <fthain@linux-m68k.org>
> ---
>  MAINTAINERS | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d7b4f32875a9..690539b2705c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5138,10 +5138,8 @@ S:	Maintained
>  F:	drivers/scsi/am53c974.c
>
>  DC395x SCSI driver
> -M:	Oliver Neukum <oliver@neukum.org>
>  M:	Ali Akcaagac <aliakc@web.de>
>  M:	Jamie Lenehan <lenehan@twibble.org>
> -L:	dc395x@twibble.org
>  S:	Maintained
>  W:	http://twibble.org/dist/dc395x/
>  W:	http://lists.twibble.org/mailman/listinfo/dc395x/
>

