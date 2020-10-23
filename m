Return-Path: <SRS0=1+Eg=D6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9E69C55178
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 06:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D71F22253
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Oct 2020 06:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S372619AbgJWG3P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 02:29:15 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:33050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S369627AbgJWG3P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Oct 2020 02:29:15 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E0EC4BBF3C1F6B357141;
        Fri, 23 Oct 2020 14:29:12 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Fri, 23 Oct 2020
 14:29:06 +0800
Subject: Re: [PATCH v1 0/5] Introduce a new helper marco
 DEFINE_STORE_ATTRIBUTE at seq_file.c
To:     Al Viro <viro@zeniv.linux.org.uk>
CC:     <akpm@linux-foundation.org>, <andriy.shevchenko@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <martin.petersen@oracle.com>,
        <john.garry@huawei.com>, <himanshu.madhani@cavium.com>,
        <felipe.balbi@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <uma.shankar@intel.com>, <anshuman.gupta@intel.com>,
        <animesh.manna@intel.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1603355997-32350-1-git-send-email-luojiaxing@huawei.com>
 <20201022122858.GT3576660@ZenIV.linux.org.uk>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <7003f142-5d53-1285-c6cd-a8e8d9c076b7@huawei.com>
Date:   Fri, 23 Oct 2020 14:29:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20201022122858.GT3576660@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi

On 2020/10/22 20:28, Al Viro wrote:
> On Thu, Oct 22, 2020 at 04:39:52PM +0800, Luo Jiaxing wrote:
>> We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
>> for read-only file, but we found many of drivers also want a helper marco for
>> read-write file too.
> DEFINE_SHOW_ATTRIBUTE is a bloody bad idea; let's not replicate the garbage
> any further.  If you want templates - C++ is over that way...


I am sorry but would you mind to explain it in more detail that why 
DEFINE_SHOW_ATTRIBUTE is a bad idea?

I found that DEFINE_SHOW_ATTRIBUTE is convenient and avoids a lot of 
duplicate code When add some debugfs file for DFX.


Thanks

Jiaxing


>
> .
>

