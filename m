Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194CEC48BDF
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03885611CE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbhFPDNY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:13:24 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4791 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhFPDNW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jun 2021 23:13:22 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G4VSj4P6DzXfhY;
        Wed, 16 Jun 2021 11:06:13 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 16 Jun 2021 11:11:14 +0800
Received: from [127.0.0.1] (10.174.179.0) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 16 Jun
 2021 11:11:14 +0800
Subject: Re: [PATCH v2 1/1] scsi: pm8001: remove unnecessary oom message
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <20210610094605.16672-1-thunder.leizhen@huawei.com>
 <20210610094605.16672-2-thunder.leizhen@huawei.com>
 <yq1a6nq5y5u.fsf@ca-mkp.ca.oracle.com>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <1f6b1864-6d85-a908-af64-95da39fb4599@huawei.com>
Date:   Wed, 16 Jun 2021 11:11:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <yq1a6nq5y5u.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.0]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/6/16 10:48, Martin K. Petersen wrote:
> 
> Zhen,
> 
>> Fixes scripts/checkpatch.pl warning:
>> WARNING: Possible unnecessary 'out of memory' message
> 
> Applied to 5.14/scsi-staging.
> 
> Instead of sending 20 individual patches to address OOM messages, please
> submit a series. That makes things much easier to track in patchwork and
> b4.

OK, I'll repost the other patches except this one as a series.

> 
> Same goes for the DEVICE_ATTR_RO changes. One series per logical change,
> one patch per driver.

OK

> 
> Thanks!
> 

