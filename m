Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB14C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E979064FE2
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 08:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhCKIvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 03:51:24 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13907 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhCKIvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 03:51:20 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dx2gy3R4YzkX78;
        Thu, 11 Mar 2021 16:49:50 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.131) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Thu, 11 Mar 2021
 16:51:09 +0800
Subject: Re: [PATCH 26/31] scsi: libsas,hisi_sas,mvsas,pm8001: Allocate
 Scsi_cmd for slow task
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-27-hare@suse.de>
 <9387eb39-b457-177a-c271-837641d19691@huawei.com>
 <b3725d65-8c9d-6007-1180-38a121372dce@huawei.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <5d4c631d-21f8-2dd2-c06b-2fac7b01c590@huawei.com>
Date:   Thu, 11 Mar 2021 16:51:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <b3725d65-8c9d-6007-1180-38a121372dce@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/3/9 22:05, John Garry wrote:
> On 09/03/2021 11:22, luojiaxing wrote:
>> Hi, Hannes, john
>>
>>
>> I found some tiny coding issues of this patch. check below.
>>
>> And if someone else have already point out, please ignore.
>>
>
> JFYI, I have put the patches on this following branch, and fixed up to 
> get building+working:
> https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.11-resv7 
>


Thanks,  I will run some full test on it later. If other issue is found, 
we discuss then


Jiaxing


>
> Thanks,
> John
>
>>
>> On 2021/2/22 21:24, Hannes Reinecke wrote:
>>> From: John Garry <john.garry@huawei.com>
>
>
> .
>

