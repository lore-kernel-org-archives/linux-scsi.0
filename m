Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A797C43465
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 01:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0118223447
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 01:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgISBwX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Sep 2020 21:52:23 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:13269 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgISBwX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 18 Sep 2020 21:52:23 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E0558EA567EBE1343187;
        Sat, 19 Sep 2020 09:52:21 +0800 (CST)
Received: from [10.174.178.248] (10.174.178.248) by smtp.huawei.com
 (10.3.19.214) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 19 Sep
 2020 09:52:21 +0800
Subject: Re: [PATCH] scsi: arcmsr: Remove the superfluous break
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
References: <20200918093230.49050-1-jingxiangfeng@huawei.com>
 <20200918145619.GA25599@embeddedor>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <lee.jones@linaro.org>, <colin.king@canonical.com>,
        <axboe@kernel.dk>, <mchehab+huawei@kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
Message-ID: <5F656454.7000407@huawei.com>
Date:   Sat, 19 Sep 2020 09:52:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20200918145619.GA25599@embeddedor>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.248]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/9/18 22:56, Gustavo A. R. Silva wrote:
> On Fri, Sep 18, 2020 at 05:32:30PM +0800, Jing Xiangfeng wrote:
>> Remove the superfluous break, as there is a 'return' before it.
>>
>
> Apparently, the change is correct. Please, just add a proper Fixes tag by
> yourself this time.

Thanks for comments! I'll resend with the following Fixes tag:

Fixes: 6b3937227479 ("arcmsr: fix command timeout under heavy load")
>
> Thanks
> --
> Gustavo
>
>> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
>> ---
>>   drivers/scsi/arcmsr/arcmsr_hba.c | 2 --
>>   1 file changed, 2 deletions(-)
>>
>> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
>> index ec895d0319f0..74add6d247d5 100644
>> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
>> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
>> @@ -2699,10 +2699,8 @@ static irqreturn_t arcmsr_interrupt(struct AdapterControlBlock *acb)
>>   	switch (acb->adapter_type) {
>>   	case ACB_ADAPTER_TYPE_A:
>>   		return arcmsr_hbaA_handle_isr(acb);
>> -		break;
>>   	case ACB_ADAPTER_TYPE_B:
>>   		return arcmsr_hbaB_handle_isr(acb);
>> -		break;
>>   	case ACB_ADAPTER_TYPE_C:
>>   		return arcmsr_hbaC_handle_isr(acb);
>>   	case ACB_ADAPTER_TYPE_D:
>> --
>> 2.17.1
>>
> .
>
