Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886AEC04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 13:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60C84613B0
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 13:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232548AbhEXNxh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 09:53:37 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3985 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbhEXNxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 09:53:36 -0400
Received: from dggems705-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Fpdqr4867zmZ1T;
        Mon, 24 May 2021 21:49:44 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggems705-chm.china.huawei.com (10.3.19.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 24 May 2021 21:52:04 +0800
Received: from [127.0.0.1] (10.40.188.252) by dggpeml500008.china.huawei.com
 (7.185.36.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 24 May
 2021 21:52:03 +0800
Subject: Re: [PATCH] scsi: hisi_sas: Use the correct HiSilicon copyright
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>
References: <1621679075-15404-1-git-send-email-fanghao11@huawei.com>
 <02ff5bb3aa4894cd8ef2b0ca9d66f4c6ba34278b.camel@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <prime.zeng@hisilicon.com>
From:   "fanghao (A)" <fanghao11@huawei.com>
Message-ID: <524a6457-260f-e11c-1090-7c1ed839bf0a@huawei.com>
Date:   Mon, 24 May 2021 21:52:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <02ff5bb3aa4894cd8ef2b0ca9d66f4c6ba34278b.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.40.188.252]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/5/22 22:56, James Bottomley wrote:
> On Sat, 2021-05-22 at 18:24 +0800, Hao Fang wrote:
>> s/Hisilicon/HiSilicon/.
>> It should use capital S, according to the official website
>> https://www.hisilicon.com/en.
>
> You can't do this.  The strict terms of the GPL require us to preserve
> intact all notices referring to copyright and licences.  If hisilicon
> truly did make a mistake when they added their original copyright
> notices, *they* may submit a patch to correct it, but you can't correct
> it for them without their permission just because you think they got it
> wrong.
>

John, can you help to review this patch and add an Acked-by? Or you can resubmit it.

Thanks.

Hao
>
>
>
> .
>

