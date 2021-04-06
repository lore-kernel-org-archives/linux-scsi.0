Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B363C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:39:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3163961396
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:39:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbhDFGjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:39:20 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15132 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244060AbhDFGjS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 02:39:18 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FDyV14WG7znXSL;
        Tue,  6 Apr 2021 14:36:25 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.131) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.498.0; Tue, 6 Apr 2021
 14:39:02 +0800
Subject: Re: [PATCH v1 1/2] scsi: pm8001: clean up for white space
To:     Bart Van Assche <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1617354522-17113-1-git-send-email-luojiaxing@huawei.com>
 <1617354522-17113-2-git-send-email-luojiaxing@huawei.com>
 <7f8aef00-07bc-6b63-19a1-85a8153387cd@acm.org>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <3dd042b3-eb86-f0aa-5542-3f763f6830e0@huawei.com>
Date:   Tue, 6 Apr 2021 14:39:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <7f8aef00-07bc-6b63-19a1-85a8153387cd@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/4/3 0:01, Bart Van Assche wrote:
> On 4/2/21 2:08 AM, Luo Jiaxing wrote:
>>   #define AAP1_MEMMAP(r, c) \
>> -	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
>> +	(*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
>>   	+ (c)))
> Since this macro is being modified, please convert it into an inline
> function such that the type of the arguments can be verified by the
> compiler.


Sure, but still keep the function name as AAP1_MEMMAP?


Thanks

Jiaxing


>
> Thanks,
>
> Bart.
>
> .
>

