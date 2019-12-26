Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C66FAC2D0DB
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:33:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A655320828
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 11:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfLZLdS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 06:33:18 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:45148 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725954AbfLZLdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Dec 2019 06:33:18 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AA2B7A1E62250C69BB90;
        Thu, 26 Dec 2019 19:33:15 +0800 (CST)
Received: from [127.0.0.1] (10.173.220.96) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 26 Dec 2019
 19:33:06 +0800
Subject: Re: [PATCH] scsi: don't memset to zero after dma_alloc_coherent
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <ysato@users.sourceforge.jp>, <dalias@libc.org>,
        <aacraid@microsemi.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <sathya.prakash@broadcom.com>,
        <chaitra.basappa@broadcom.com>,
        <suganath-prabu.subramani@broadcom.com>
CC:     <linux-sh@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <MPT-FusionLinux.pdl@broadcom.com>,
        <zhengbin13@huawei.com>, <yi.zhang@huawei.com>
References: <20191225132327.7121-1-yukuai3@huawei.com>
 <a3b27b94-1ab6-c33f-611c-56143fd390f8@cogentembedded.com>
 <958ffbe5-f3da-da16-9f2b-05923d13485b@huawei.com>
 <68771eb5-03c4-422b-9956-930a0e3c9de8@cogentembedded.com>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <bbec6a4a-2c57-2254-2970-95acb098c7f3@huawei.com>
Date:   Thu, 26 Dec 2019 19:33:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <68771eb5-03c4-422b-9956-930a0e3c9de8@cogentembedded.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.220.96]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2019/12/26 19:16, Sergei Shtylyov wrote:
> On 26.12.2019 14:13, yukuai (C) wrote:
> 
>>>> dma_alloc_coherent already zeros out memory, so memset to zero is not
>>>> needed.
>>>>
>>>> Signed-off-by: yu kuai <yukuai3@huawei.com>
>>>> ---
>>>>   arch/sh/mm/consistent.c             | 2 --
>>>
>>>     How this one is related to SCSI?
>>>
>> Thank you for your response!
>> I put them in the same patch because I thougt they are the same 
>> situation. I'm sorry if it's not appropriate.
> 
>     I'd recommend to split such patch to (at least) different 
> subsystems, e.g. arch/sh/ part, drivers/scsi/ part.

I'll do that, thank you again for your advise!

Yu Kuai

