Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70C7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 08:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbhLOIAt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 03:00:49 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29198 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236127AbhLOIAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 03:00:48 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JDSL16QNhz8vqB;
        Wed, 15 Dec 2021 15:58:33 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 16:00:41 +0800
Subject: Re: [PATCH 09/15] scsi: libsas: Resume sas host before sending SMP
 IOs
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-10-git-send-email-chenxiang66@hisilicon.com>
 <017482f2-47a0-f924-629e-88e956ce3f61@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <f9bb9fee-0c80-2948-6ee0-c31055fe5c87@hisilicon.com>
Date:   Wed, 15 Dec 2021 16:00:40 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <017482f2-47a0-f924-629e-88e956ce3f61@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 19:12, John Garry 写道:
> Please consider these points:
>

> About "scsi: libsas: Resume sas host before sending SMP IOs", just 
> have "Resume host while sending SMP IOs"
>
> On 17/11/2021 02:45, chenxiang wrote:
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>> Need to resume sas host before sending SMP IOs to ensure that
>> SMP IOs are sent sucessfully.
>
> successfully

ok

>
> >
>
> When sending SMP IOs to the host we need to ensure that that host is 
> not suspended and may handle the commands. This is a better approach 
> than relying on the host to resume itself to handle such commands. So 
> use pm_runtime_get_sync() and pm_runtime_get_sync() calls for the host 
> when executing SMP tasks.

Ok, i will rewrite it.

>
>>
>> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
>> Reviewed-by: John Garry<john.garry@huawei.com>
>
>
> .
>


