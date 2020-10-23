Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0896C55179
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 08:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 772082080C
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 08:53:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S460790AbgJWIxj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 04:53:39 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S460768AbgJWIxj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Oct 2020 04:53:39 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CF2FE3B578607A66884D;
        Fri, 23 Oct 2020 16:53:34 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 23 Oct 2020
 16:53:26 +0800
Subject: Re: [PATCH v1 1/5] seq_file: Introduce DEFINE_STORE_ATTRIBUTE()
 helper macro
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     <akpm@linux-foundation.org>, <viro@zeniv.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1603355997-32350-1-git-send-email-luojiaxing@huawei.com>
 <1603355997-32350-2-git-send-email-luojiaxing@huawei.com>
 <20201022142213.GC4077@smile.fi.intel.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <9e25f256-3381-ed0f-be79-69ae631170de@huawei.com>
Date:   Fri, 23 Oct 2020 16:53:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20201022142213.GC4077@smile.fi.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

On 2020/10/22 22:22, Andy Shevchenko wrote:
> On Thu, Oct 22, 2020 at 04:39:53PM +0800, Luo Jiaxing wrote:
>> We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
>> for read-only file, but we found many of drivers want a helper marco for
>> read-write file too.
> I would expect that DEFINE_STORE maps to WO attribute...
> For RW SHOW_STORE would be more appropriate.
>
> Otherwise I think it makes sense.


Thanks for the review, it's true that the name is a bit inappropriate.

I'll change the name if I get a v2 patch.

But AI doesn't seem to like this macro  : )


Thanks

Jiaxing


>

