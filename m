Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825CFC43381
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5366F2339E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 16:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732392AbhAOQbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jan 2021 11:31:46 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2359 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730569AbhAOQbp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2021 11:31:45 -0500
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DHRPS6fcfz67cP6;
        Sat, 16 Jan 2021 00:25:48 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 15 Jan 2021 17:31:03 +0100
Received: from [10.47.4.21] (10.47.4.21) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Fri, 15 Jan
 2021 16:31:02 +0000
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com> <X/2h0yNqtmgoLIb+@lx-t490>
 <e9bc0c89-a4d6-1e5b-793d-3c246882210e@huawei.com> <X/3dUkPCC1SrLT4m@lx-t490>
 <20e1034c-98af-a000-65ed-ae5f0e7a758f@huawei.com> <YAHCbcNea47Zk+4w@lx-t490>
From:   John Garry <john.garry@huawei.com>
Message-ID: <869c00f4-a9a6-e124-3104-906957754dc5@huawei.com>
Date:   Fri, 15 Jan 2021 16:29:51 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YAHCbcNea47Zk+4w@lx-t490>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.4.21]
X-ClientProxiedBy: lhreml708-chm.china.huawei.com (10.201.108.57) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/01/2021 16:27, Ahmed S. Darwish wrote:
> Thanks!
> 
> Shall I add you r-b tag to the whole series then, or only to the ones
> which directly touch libsas (#3, #12, #16, and #19)?

The whole series, if you like. But there was a nit about fitting some 
code on a single line still, and I think Christoph also had some issue 
on that related topic.

> 
>> As an aside, your analysis showed some quite poor usage of spinlocks in some
>> drivers, specifically grabbing a lock and then calling into a depth of 3 or
>> 4 functions.
>>
> Correct.

BTW, testing report looked all good.

Thanks,
john
