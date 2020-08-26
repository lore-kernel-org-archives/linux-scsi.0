Return-Path: <SRS0=243Y=CE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0CB0C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 09:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FCE207DF
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Aug 2020 09:49:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgHZJti convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Aug 2020 05:49:38 -0400
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:38435 "EHLO
        outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727997AbgHZJth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Aug 2020 05:49:37 -0400
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost.zedat.fu-berlin.de (Exim 4.93)
          with esmtps (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@zedat.fu-berlin.de>)
          id 1kAs3g-001QRa-BS; Wed, 26 Aug 2020 11:49:32 +0200
Received: from tmo-117-196.customers.d1-online.com ([80.187.117.196] helo=localhost.localdomain)
          by inpost2.zedat.fu-berlin.de (Exim 4.93)
          with esmtpsa (TLS1.2)
          tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
          (envelope-from <glaubitz@physik.fu-berlin.de>)
          id 1kAs3g-0020Ib-1g; Wed, 26 Aug 2020 11:49:32 +0200
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 17/19] z2ram: reindent
Date:   Wed, 26 Aug 2020 11:49:29 +0200
Message-Id: <EF673A30-F88D-4E4E-8A2B-E942153830AC@physik.fu-berlin.de>
References: <8570915f668159f93ba2eb845a3bbc05f8ee3a99.camel@perches.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
In-Reply-To: <8570915f668159f93ba2eb845a3bbc05f8ee3a99.camel@perches.com>
To:     Joe Perches <joe@perches.com>
X-Mailer: iPhone Mail (18A5351d)
X-Original-Sender: glaubitz@physik.fu-berlin.de
X-Originating-IP: 80.187.117.196
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Aug 26, 2020, at 11:21 AM, Joe Perches <joe@perches.com> wrote:
> 
> ﻿On Wed, 2020-08-26 at 08:24 +0200, Christoph Hellwig wrote:
>> reindent the driver using Lident as the code style was far away from
>> normal Linux code.
> 
> Why?  Does anyone use this anymore?

Yes, the Amiga and Linux/m68k is very well and alive. There is new hardware being developed and new drivers being developed and so on.

Please let’s don’t have another discussion about that. The code is maintained which is what counts and not whether any corporation is still making money with it.

Adrian
