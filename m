Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F3BC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 08:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbiCQIrq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 04:47:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiCQIro (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 04:47:44 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0961CABD6
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 01:46:25 -0700 (PDT)
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KK11m25dhz67KmH;
        Thu, 17 Mar 2022 16:45:32 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 17 Mar 2022 09:46:21 +0100
Received: from [10.47.84.96] (10.47.84.96) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Mar
 2022 08:46:21 +0000
Message-ID: <c474939d-91b7-1c30-d74c-5f473b464260@huawei.com>
Date:   Thu, 17 Mar 2022 08:46:20 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v5] scsi:spraid: initial commit of Ramaxel spraid driver
To:     Bart Van Assche <bvanassche@acm.org>,
        Yanling Song <songyl@ramaxel.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>
References: <20220314025315.96674-1-songyl@ramaxel.com>
 <ecf79a5c-49f4-cf0e-edf4-9363c8b60bb5@huawei.com>
 <19494279-78f9-ca48-3c09-091df342cd63@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <19494279-78f9-ca48-3c09-091df342cd63@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.84.96]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/03/2022 23:03, Bart Van Assche wrote:
>> [ ... ]
>> why do you need a separate header file? why not put all this in the 
>> only C file?
> 
> The C file is already very big. I like the approach of keeping 
> declarations and structure definitions in a header file because that 
> makes the code easier to navigate.

If the file is huge and hard to navigate then I would suggest multiple C 
files with a common header file to share defines.

But I don't feel too strongly about that.

However, I would be keen on seeing a leaner driver.

> 
>>> +struct spraid_completion {
>>> +    __le32 result;
>>
>> I think that __le32 is used for userspace common defines, while we use 
>> le32 for internal to kernel
> 
> Really? I'm not aware of a le32 type in the Linux kernel.

That's my mistake - you're right. I was thinking of u32 vs __u32

> 
>>> +#define SPRAID_DRV_VERSION    "1.0.0.0"
>>
>> I don't see much value in driver versioning. As I see, the kernel 
>> version is the driver version.
> 

thanks,
John

