Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58BC7C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 13:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 109186113B
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 13:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbhDHNEN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:04:13 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15626 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbhDHNEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Apr 2021 09:04:13 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FGLx54JQdzpWWL;
        Thu,  8 Apr 2021 21:01:13 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.131) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Thu, 8 Apr 2021
 21:03:54 +0800
Subject: Re: [PATCH v1 0/2] scsi: libsas: few clean up patches
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chenxiang66@hisilicon.com>, <linuxarm@openeuler.org>
References: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <738d6d4a-0052-1b0c-e619-370f62506189@huawei.com>
Date:   Thu, 8 Apr 2021 21:03:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

kindly ping


Hi, jejb, martin, would you mind to take a look for these tiny clean up 
patches.


Thanks

Jiaxing


On 2021/3/25 20:29, Luo Jiaxing wrote:
> Two types of errors are detected by the checkpatch.
> 1. Alignment between switches and cases
> 2. Improper use of some spaces
>
> Here are the clean up patches.
>
> Luo Jiaxing (2):
>    scsi: libsas: make switch and case at the same indent in
>      sas_to_ata_err()
>    scsi: libsas: clean up for white spaces
>
>   drivers/scsi/libsas/sas_ata.c      | 74 ++++++++++++++++++--------------------
>   drivers/scsi/libsas/sas_discover.c |  2 +-
>   drivers/scsi/libsas/sas_expander.c | 15 ++++----
>   3 files changed, 43 insertions(+), 48 deletions(-)
>

