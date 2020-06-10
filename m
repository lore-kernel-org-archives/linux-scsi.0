Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1AEC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FFC2207ED
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 05:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgFJFgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 01:36:25 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:17513 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbgFJFgZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jun 2020 01:36:25 -0400
Received: from [192.168.1.41] ([92.140.207.208])
        by mwinf5d88 with ME
        id pHcL2200B4WJoZY03HcMMv; Wed, 10 Jun 2020 07:36:23 +0200
X-ME-Helo: [192.168.1.41]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 10 Jun 2020 07:36:23 +0200
X-ME-IP: 92.140.207.208
Subject: Re: [PATCH] scsi: eesox: Fix different dev_id between 'request_irq()'
 and 'free_irq()'
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux@armlinux.org.uk
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20200530073418.577210-1-christophe.jaillet@wanadoo.fr>
 <159175686975.7062.16533438955437978870.b4-ty@oracle.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <26d388f5-be67-b643-c76c-b9fe52f111f7@wanadoo.fr>
Date:   Wed, 10 Jun 2020 07:36:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <159175686975.7062.16533438955437978870.b4-ty@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Le 10/06/2020 à 04:41, Martin K. Petersen a écrit :
> On Sat, 30 May 2020 09:34:18 +0200, Christophe JAILLET wrote:
>
>> The dev_id used in 'request_irq()' and 'free_irq()' should match.
>> So use 'host' in both cases.
> Applied to 5.8/scsi-queue, thanks!
>
> [1/1] scsi: eesox: Fix different dev_id between request_irq() and free_irq()
>        https://git.kernel.org/mkp/scsi/c/3bab76807d95
>
Please revert, the patch is bogus, as spotted by Russell King - ARM 
Linux admin <linux@armlinux.org.uk>.
See [1].

I'll try to send the correct fix by this week-end.

CJ

[1]: https://marc.info/?l=linux-scsi&m=159083184215730&w=4

