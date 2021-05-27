Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8C87C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 02:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4B29613C3
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 02:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhE0CNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 22:13:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:3955 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232236AbhE0CNS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 22:13:18 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FrB7k5sZkz81Qq;
        Thu, 27 May 2021 10:08:50 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 10:11:43 +0800
Received: from [127.0.0.1] (10.174.177.72) by dggpemm500006.china.huawei.com
 (7.185.36.236) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 27 May
 2021 10:11:43 +0800
Subject: Re: Aw: [EXT] Re: [PATCH 1/1] scsi: Fix spelling mistakes in header
 files
To:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        <open-iscsi@googlegroups.com>, <dgilbert@interlog.com>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>
References: <20210517095945.7363-1-thunder.leizhen@huawei.com>
 <162200196243.11962.5629932935575912565.b4-ty@oracle.com>
 <60AE2272020000A100041478@gwsmtp.uni-regensburg.de>
From:   "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Message-ID: <215847b9-f64d-8cb2-e53b-13123770ca1a@huawei.com>
Date:   Thu, 27 May 2021 10:11:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <60AE2272020000A100041478@gwsmtp.uni-regensburg.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2021/5/26 18:26, Ulrich Windl wrote:
> (Amazingly I also did think "busses" is correct -- seems to be a common mistake; maybe only for Germans that would pronounce "busses" differently from "buses"...)

I just googled: busses or buses

Busses isn't a misspelling, it's just that few people use it these days. The link below makes it clear:

https://www.merriam-webster.com/words-at-play/plural-of-bus

> 
> 
>>>> Martin K. Petersen 26.05.2021, 06:08 >>>
> 
> On Mon, 17 May 2021 17:59:45 +0800, Zhen Lei wrote:
> 
>> Fix some spelling mistakes in comments:
>> pathes ==> paths
>> Resouce ==> Resource
>> retreived ==> retrieved
>> keep-alives ==> keep-alive
>> recevied ==> received
>> busses ==> buses
>> interruped ==> interrupted
> 
> Applied to 5.14/scsi-queue, thanks!
> 
> [1/1] scsi: Fix spelling mistakes in header files
> https://git.kernel.org/mkp/scsi/c/40d6b939e4df
> 
> --
> Martin K. Petersen Oracle Linux Engineering
> 
> --
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to open-iscsi+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/open-iscsi/162200196243.11962.5629932935575912565.b4-ty%40oracle.com.
> 
> 
> .
> 

