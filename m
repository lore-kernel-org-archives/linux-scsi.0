Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 813ACC2D0EB
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 08:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 626C620757
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 08:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgC3I5D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 04:57:03 -0400
Received: from mail.archive.org ([207.241.224.6]:50152 "EHLO mail.archive.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729664AbgC3I5D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 04:57:03 -0400
Received: from mail.archive.org (localhost [127.0.0.1])
        by mail.archive.org (Postfix) with ESMTP id 90BA621038;
        Mon, 30 Mar 2020 08:57:02 +0000 (UTC)
Received: from [0.0.0.0] (a82-161-36-93.adsl.xs4all.nl [82.161.36.93])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: merlijn@archive.org)
        by mail.archive.org (Postfix) with ESMTPSA id 4BC872102D;
        Mon, 30 Mar 2020 08:57:01 +0000 (UTC)
Subject: Re: [PATCH] sr: Fix sr_block_release()
From:   "Merlijn B.W. Wajer" <merlijn@archive.org>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@kernel.org, simon@octiron.net
References: <20200330025151.10535-1-bvanassche@acm.org>
 <ed0b6af3-94c3-c184-f3fc-e6181ac0e843@archive.org>
Message-ID: <93329ddc-17c5-ff4d-ab9e-cb403056bc08@archive.org>
Date:   Mon, 30 Mar 2020 10:58:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ed0b6af3-94c3-c184-f3fc-e6181ac0e843@archive.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Envelope-From: <merlijn@archive.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 30/03/2020 10:51, Merlijn B.W. Wajer wrote:
> Hi,
> 
> Oops, looks like Simon (CC) reported this earlier on too, missed that.
> 
> On 30/03/2020 04:51, Bart Van Assche wrote:
>> This patch fixes the following two complaints:
> 
> Acked-By: Merlijn Wajer <merlijn@archive.org>

BTW: Looks like my/the original patch (which fixes a performance
regression causing no more than one CD to be used efficiently at a time)
never went into stable in the first place. Shall I submit a patch
amended with this fix for inclusion in stable?

Cheers,
Merlijn
