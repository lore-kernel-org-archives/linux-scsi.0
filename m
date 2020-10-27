Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76D8C5DF9E
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 16:43:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D68821707
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 16:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1811907AbgJ0Qnj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 12:43:39 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:3001 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1811880AbgJ0Qng (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 12:43:36 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 890D77F814ACED51556B;
        Tue, 27 Oct 2020 16:43:34 +0000 (GMT)
Received: from [10.47.8.138] (10.47.8.138) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 27 Oct
 2020 16:43:33 +0000
Subject: Re: [PATCH 1/3] genirq/affinity: Add irq_update_affinity_desc()
To:     Thomas Gleixner <tglx@linutronix.de>, <gregkh@linuxfoundation.org>,
        <rafael@kernel.org>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <maz@kernel.org>
References: <1603800624-180488-1-git-send-email-john.garry@huawei.com>
 <1603800624-180488-2-git-send-email-john.garry@huawei.com>
 <87h7qf1yp0.fsf@nanos.tec.linutronix.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <0f12f562-e4e1-0c0b-be4c-00f40e86d9bc@huawei.com>
Date:   Tue, 27 Oct 2020 16:40:13 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <87h7qf1yp0.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.138]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Thomas,

>> From: Thomas Gleixner <tglx@linutronix.de>
>>
>> Add a function to allow the affinity of an interrupt be switched to
>> managed, such that interrupts allocated for platform devices may be
>> managed.
>>
>> <Insert author sob>
>>
>> [jpg: Add commit message and add prototypes]
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> ---
>> Thomas, I just made you author since you provided the original code, hope
>> it's ok.
> 
> I already forgot about this.

We needed some changes to go in to make the block CPU hotplug handling 
usable for some scsi drivers, which took a while.

> And in fact I only gave you a broken
> example. So just make yourself the author and add Suggested-by: tglx.
> 

ok, will repost with that, cheers

> Vs. merging. I'd like to pick that up myself as I might have other
> changes in that area coming up.
> 
> I'll do it as a single commit on top of rc1 and tag it so the scsi
> people can just pull it in.

I guess it's ok, I will defer to the maintainers on that.

Thanks,
John

