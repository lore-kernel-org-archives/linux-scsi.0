Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F32C1C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:25:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbhLOHZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:25:24 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29196 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbhLOHZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:25:24 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JDRY93ggTz8vvW;
        Wed, 15 Dec 2021 15:23:09 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:25:22 +0800
Subject: Re: [PATCH 07/15] scsi: libsas: Send event PORTE_BROADCAST_RCVD for
 valid ports
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-8-git-send-email-chenxiang66@hisilicon.com>
 <39179771-6422-ff6c-deed-27b204081e28@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <ef9c05b2-71c7-a72a-3128-d6e74de1fe98@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:25:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <39179771-6422-ff6c-deed-27b204081e28@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 19:02, John Garry 写道:
> Please consider these points:
>
> About "Send event PORTE_BROADCAST_RCVD for valid ports":
>
> Maybe say "Insert PORTE_BROADCAST_RCVD event for resuming host", as 
> "valid ports" is a little vague. And the point is that we can to 
> rescan when we resume.
ok

>
> On 17/11/2021 02:45, chenxiang wrote:
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>> If inserting a new disk for expander, the disk will not be revalidated
>> as the topology is not re-scanned during the resume process. So send 
>> event
>> PORTE_BROADCAST_RCVD to identify some new inserted disks for expander.
>
> If a new disk is inserted through an expander when the host was 
> suspended, they will not necessarily be detected as the topology is 
> not re-scanned during resume.
>
> To detect possible changes in topology during suspension, insert a 
> PORTE_BROADCAST_RCVD event per port when resuming to trigger a 
> revalidation.

Thanks, i will change it in next version.

>
>>
>> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
>> Reviewed-by: John Garry<john.garry@huawei.com>
>
>
> .
>


