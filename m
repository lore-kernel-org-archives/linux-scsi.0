Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00292C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 12:26:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC587610A8
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 12:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhDHM0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 08:26:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16048 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhDHM0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 08:26:18 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FGL5K6l9XzNtyT;
        Thu,  8 Apr 2021 20:23:17 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.131) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 20:25:58 +0800
Subject: Re: [PATCH v2 0/2] scsi: pm8001: tiny clean up patches
To:     <jinpu.wang@cloud.ionos.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1617790059-43125-1-git-send-email-luojiaxing@huawei.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <ec7ff830-6d65-a174-52f2-db6573be5121@huawei.com>
Date:   Thu, 8 Apr 2021 20:25:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1617790059-43125-1-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A reply to v1 cause v2 code need to be modified, so please ignore this, 
and directly check v3 later.


Thanks

Jiaxing

On 2021/4/7 18:07, Luo Jiaxing wrote:
> Several error is reported by checkpatch.pl, here are two patches to clean
> them up.
>
> ---
>     v1->v2:
>            1. modify AAP1_MEMMAP() to inline function
>            2. set flash_command_table and flash_error_table as const
> ---
>
> Luo Jiaxing (2):
>    scsi: pm8001: clean up for white space
>    scsi: pm8001: clean up for open brace
>
>   drivers/scsi/pm8001/pm8001_ctl.c | 26 +++++++++++---------------
>   drivers/scsi/pm8001/pm8001_ctl.h |  5 +++++
>   drivers/scsi/pm8001/pm8001_hwi.c | 14 +++++++-------
>   drivers/scsi/pm8001/pm8001_sas.c | 20 ++++++++++----------
>   drivers/scsi/pm8001/pm8001_sas.h |  2 +-
>   drivers/scsi/pm8001/pm80xx_hwi.c | 14 +++++++-------
>   6 files changed, 41 insertions(+), 40 deletions(-)
>

