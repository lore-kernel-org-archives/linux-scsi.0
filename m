Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92000C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60011610CF
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 18:58:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbhDJS7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 14:59:10 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:47006 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234768AbhDJS7K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 14:59:10 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru C2B34209998C
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] scsi: hisi_sas: fix IRQ checks
To:     John Garry <john.garry@huawei.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
 <73de21af-8097-9bd3-9da4-32c9523fa148@omprussia.ru>
 <67ebfc0b-7de5-376c-1f78-a696eb719cce@huawei.com>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <4938827a-0778-c149-1df5-2ce9a9de8268@omprussia.ru>
Date:   Sat, 10 Apr 2021 21:58:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <67ebfc0b-7de5-376c-1f78-a696eb719cce@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello!

On 4/6/21 10:43 AM, John Garry wrote:

[...]
>>> Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
>>> into account that irq_of_parse_and_map() and platform_get_irq() have a
>>> different way of indicating an error: the former returns 0 and the latter
>>> returns a negative error code. Fix up the IRQ checks!
>>>
>>> Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
>>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
>>>
>>> ---
>>
>>     Sorry, forgot to mention that this patch is against the 'fixes' branch of
>> Martin Petgersen's 'scsi.git' repo.
> 
> JFYI, The HW for this v1 hw driver is all but dead, and I was considering deleting the driver.
> 
> But, for now, if you want to fix up to ensure no one copies this pattern, then fine.

   Yeah, that too. And the -stable kernels also need to be considered...

> Thanks,
> John

MBR, Sergey
