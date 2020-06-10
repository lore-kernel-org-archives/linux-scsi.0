Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC59C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5232207F9
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726123AbgFJFgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 01:36:00 -0400
Received: from ciao.gmane.io ([159.69.161.202]:57980 "EHLO ciao.gmane.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgFJFf7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 01:35:59 -0400
Received: from list by ciao.gmane.io with local (Exim 4.92)
        (envelope-from <lnx-linux-scsi@m.gmane-mx.org>)
        id 1jitP3-000Xg9-H8
        for linux-scsi@vger.kernel.org; Wed, 10 Jun 2020 07:35:57 +0200
X-Injected-Via-Gmane: http://gmane.org/
To:     linux-scsi@vger.kernel.org
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH] scsi: powertec: Fix different dev_id between
 'request_irq()' and 'free_irq()'
Date:   Wed, 10 Jun 2020 07:35:49 +0200
Message-ID: <08f63617-03df-71cf-70c4-00f08a9f51d8@wanadoo.fr>
References: <20200530072933.576851-1-christophe.jaillet@wanadoo.fr>
 <159175686974.7062.8526082970785072740.b4-ty@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
In-Reply-To: <159175686974.7062.8526082970785072740.b4-ty@oracle.com>
Content-Language: en-US
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20200610053549.hTIX6VsuDU9j9SBdLnDuqgzknpioXKvKrBk3nnA073Q@z>

Le 10/06/2020 à 04:41, Martin K. Petersen a écrit :
> On Sat, 30 May 2020 09:29:33 +0200, Christophe JAILLET wrote:
>
>> The dev_id used in 'request_irq()' and 'free_irq()' should match.
>> So use 'host' in both cases.
> Applied to 5.8/scsi-queue, thanks!
>
> [1/1] scsi: powertec: Fix different dev_id between request_irq() and free_irq()
>        https://git.kernel.org/mkp/scsi/c/af7b415a1ebf
>
Please revert, the patch is bogus, as spotted by Russell King - ARM 
Linux admin <linux@armlinux.org.uk>.
See [1].

I'll try to send the correct fix by this week-end.

CJ

[1]: https://marc.info/?l=linux-scsi&m=159083184215730&w=4


