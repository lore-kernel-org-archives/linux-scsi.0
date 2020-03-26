Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99139C43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 14:36:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BE3420714
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 14:36:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgCZOg6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:36:58 -0400
Received: from hosting.gsystem.sk ([212.5.213.30]:59092 "EHLO
        hosting.gsystem.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgCZOg6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 10:36:58 -0400
Received: from [192.168.1.3] (ns.gsystem.sk [62.176.172.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id 4E29A7A01D1;
        Thu, 26 Mar 2020 15:36:56 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     Arun Easi <aeasi@marvell.com>
Subject: Re: NULL pointer dereference in qla24xx_abort_command
Date:   Thu, 26 Mar 2020 15:36:51 +0100
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
Message-Id: <202003261536.51981.linux@zary.sk>
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

The server is a backup production server so there's no room for such 
experiments.

BTW. Which one is "the latest upstream kernel"? kernel.org says:
mainline:  5.6-rc7  2020-03-23
stable:    5.5.13   2020-03-25
longterm:  5.4.28   2020-03-25
longterm:  4.19.113 2020-03-25
longterm:  4.14.174 2020-03-20
longterm:  4.9.217  2020-03-20
longterm:  4.4.217  2020-03-20
longterm:  3.16.82  2020-02-11

Maybe you can point me to patches that could fix the problem?

-- 
Ondrej Zary
