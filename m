Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECE4CC83F3F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Sep 2023 07:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352289AbjIDHM7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Sep 2023 03:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjIDHM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Sep 2023 03:12:58 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39A55A0;
        Mon,  4 Sep 2023 00:12:55 -0700 (PDT)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RfKXW4dffzTlT1;
        Mon,  4 Sep 2023 15:10:19 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 4 Sep 2023 15:12:53 +0800
Message-ID: <8b8f4005-3058-d41b-2f40-18584c69e2fd@huawei.com>
Date:   Mon, 4 Sep 2023 15:12:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v4 0/5] Introduce a new helper macro
 DEFINE_SHOW_STORE_ATTRIBUTE at seq_file.c
Content-Language: en-CA
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC:     Luo Jiaxing <luojiaxing@huawei.com>, <akpm@linux-foundation.org>,
        <viro@zeniv.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <martin.petersen@oracle.com>, <john.garry@huawei.com>,
        <himanshu.madhani@cavium.com>, <felipe.balbi@linux.intel.com>,
        <gregkh@linuxfoundation.org>, <uma.shankar@intel.com>,
        <anshuman.gupta@intel.com>, <animesh.manna@intel.com>,
        <linux-usb@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1605164864-58944-1-git-send-email-luojiaxing@huawei.com>
 <ZPDZtR8W1TLcOHW+@smile.fi.intel.com>
 <14010198-c128-4960-0d56-5ee28f4da53f@huawei.com>
 <ZPGmulPTWGa1W3OM@smile.fi.intel.com>
From:   yangxingui <yangxingui@huawei.com>
In-Reply-To: <ZPGmulPTWGa1W3OM@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.120.108]
X-ClientProxiedBy: dggpemm500006.china.huawei.com (7.185.36.236) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2023/9/1 16:54, Andy Shevchenko wrote:
> On Fri, Sep 01, 2023 at 03:11:38PM +0800, yangxingui wrote:
>> On 2023/9/1 2:19, Andy Shevchenko wrote:
>>> On Thu, Nov 12, 2020 at 03:07:38PM +0800, Luo Jiaxing wrote:
>>>> We already own DEFINE_SHOW_ATTRIBUTE() helper macro for defining attribute
>>>> for read-only file, but we found many of drivers also want a helper macro
>>>> for read-write file too.
>>>>
>>>> So we add this macro to help decrease code duplication.
>>>
>>> Are you going to pursue this one?
>> Hi Andy
>>
>> Jiaxing has left his job, and his email is invalid.
> 
> OK! Anybody else to continue this to be finished?
I'll continue to do this for him. Thank you for your attention and 
advice. We'll apply it only to the scsi subsystem first.

Thanks.

Xingui
> 
