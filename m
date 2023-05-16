Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CE9C77B7F
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 11:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbjEPLVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 07:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231920AbjEPLVS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 07:21:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C95A9
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 04:21:17 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QLCvb0WFtzTkfK;
        Tue, 16 May 2023 19:00:43 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 19:05:29 +0800
Subject: Re: [PATCH] scsi: MAINTAINERS: Add a libsas entry
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        John Garry <john.g.garry@oracle.com>
References: <20230516025343.2050704-1-yanaijie@huawei.com>
 <ZGNJFQztGO+bj6jV@x1-carbon>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <6e029654-1602-7603-3051-b5efbe32f469@huawei.com>
Date:   Tue, 16 May 2023 19:05:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ZGNJFQztGO+bj6jV@x1-carbon>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/5/16 17:12, Niklas Cassel wrote:
> On Tue, May 16, 2023 at 10:53:43AM +0800, Jason Yan wrote:
>> John has been reviewing libsas patches for years. And I have been
>> contributing to libsas for years and I am interested in reviewing and
>> testing libsas patches too. So add a libsas entry and add John and me
>> as reviewer.
>>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   MAINTAINERS | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 7e0b87d5aa2e..a789811f6092 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -18767,6 +18767,16 @@ F:	include/linux/wait.h
>>   F:	include/uapi/linux/sched.h
>>   F:	kernel/sched/
>>   
>> +SCSI LIBSAS SUBSYSTEM
>> +R:	John Garry <john.g.garry@oracle.com>
>> +R:	Jason Yan <yanaijie@huawei.com>
>> +L:	linux-scsi@vger.kernel.org
>> +S:	Supported
>> +F:	drivers/scsi/libsas
> 
> I would have preferred a final slash after libsas to more clearly highlight
> that it is a directory, similar to how e.g. drivers/scsi/ or drivers/nvme/
> is specified.

Thank you for the suggestion. Updated.

Thanks,
Jason

> 
>> +F:	include/scsi/libsas.h
>> +F:	include/scsi/sas_ata.h
>> +F:	Documentation/scsi/libsas.rst
>> +
>>   SCSI RDMA PROTOCOL (SRP) INITIATOR
>>   M:	Bart Van Assche <bvanassche@acm.org>
>>   L:	linux-rdma@vger.kernel.org
>> -- 
>> 2.31.1
>>
> 
> Regardless:
> Acked-by: Niklas Cassel <niklas.cassel@wdc.com>
> .
> 
