Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5F4C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 07:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3069613B2
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 07:26:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhDMH0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 03:26:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16906 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhDMH0Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 03:26:24 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FKHCt69fJzlXP5;
        Tue, 13 Apr 2021 15:24:10 +0800 (CST)
Received: from [127.0.0.1] (10.174.179.202) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Tue, 13 Apr 2021
 15:25:57 +0800
Subject: Re: [PATCH 0/3] scsi: mptfusion: Clear the warnings indicating that
 the variable is not used
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux . pdl" <MPT-FusionLinux.pdl@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
References: <20210408061851.3089-1-thunder.leizhen@huawei.com>
 <yq1blai7p1z.fsf@ca-mkp.ca.oracle.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <7b538451-4e1e-4f4b-36e5-ad496ab40598@huawei.com>
Date:   Tue, 13 Apr 2021 15:25:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <yq1blai7p1z.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.202]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/4/13 13:07, Martin K. Petersen wrote:
> 
> Zhen,
> 
>> Zhen Lei (3):
>>   scsi: mptfusion: Remove unused local variable 'time_count'
>>   scsi: mptfusion: Remove unused local variable 'port'
>>   scsi: mptfusion: Fix error return code of mptctl_hp_hostinfo()
> 
> I applied patches 1+2. I hesitate making functional changes to such an
> old driver.

I think patch 3 does not change any functions. The current modification only
ensures that error codes are correctly returned in the error branch. In the
previous version, 0 is always returned.

> 

