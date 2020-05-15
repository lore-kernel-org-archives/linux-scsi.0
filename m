Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4401AC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 13:31:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 227D120758
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 13:31:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgEONbK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 09:31:10 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:43224 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgEONbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 09:31:10 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2020 09:31:09 EDT
Received: from [192.168.1.3] (ns.gsystem.sk [62.176.172.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 7FF817A01D9;
        Fri, 15 May 2020 15:21:52 +0200 (CEST)
From:   Ondrej Zary <linux@zary.sk>
To:     Arun Easi <aeasi@marvell.com>
Subject: Re: NULL pointer dereference in qla24xx_abort_command
Date:   Fri, 15 May 2020 15:21:49 +0200
User-Agent: KMail/1.9.10
Cc:     linux-scsi@vger.kernel.org
References: <202003251906.40982.linux@zary.sk> <alpine.LRH.2.21.9999.2003251431090.28238@irv1user01.caveonetworks.com>
In-Reply-To: <alpine.LRH.2.21.9999.2003251431090.28238@irv1user01.caveonetworks.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202005151521.50091.linux@zary.sk>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wednesday 25 March 2020, Arun Easi wrote:
> On Wed, 25 Mar 2020, 11:06am, Ondrej Zary wrote:
> > Hi Himanshu,
> > could you please look into this bug?
> > https://urldefense.proofpoint.com/v2/url?u=https-3A__www.spinics.net_list
> >s_linux-2Dscsi_msg138637.html&d=DwICAg&c=nKjWec2b6R0mOyPaz7xtfQ&r=XB49zT5-
> >k3oWvfMuBJCeRK5Sk6o3bkGM6ewB3QuTOME&m=ezZ2dt9wVYnM-c6jJKx9bPQ0-7vbSf5HQ0bG
> >qri_iNE&s=wriOIaA9pVuKVrGPMvcZstNdYbzcZgFVw_OKiM0idIg&e=
> >
...
> 
> Ondrej,
>
> Could you pick up the latest upstream kernel and retry your test (even if
> it takes longer to reproduce)? That way we do not need to spend time on an
> issue that may have already been fixed.
>
> Regards,
> -Arun

It crashed again yesterday (4.19.118-2), almost two months since the last 
crash :(

Now I installed 5.5.17-1~bpo10+1 from Debian backports and am going to wait 
another 2 months...

-- 
Ondrej Zary
