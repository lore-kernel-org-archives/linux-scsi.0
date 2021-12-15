Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C34C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:52:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhLOHwn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:52:43 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:16812 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhLOHwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:52:43 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JDSBP3DGKz91lv;
        Wed, 15 Dec 2021 15:51:57 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:52:41 +0800
Subject: Re: [PATCH 15/15] scsi: hisi_sas: Use autosuspend for SAS controller
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-16-git-send-email-chenxiang66@hisilicon.com>
 <ac517067-b119-0a47-bf65-ec9e3fcf9944@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <caa6e61f-87c4-6597-c059-b14eaee31516@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:52:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <ac517067-b119-0a47-bf65-ec9e3fcf9944@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 18:50, John Garry 写道:
> Please consider this rewrite:

ok, i will consider to rewrite it in next version

>
> On 17/11/2021 02:45, chenxiang wrote:
>
> scsi: hisi_sas: Use autosuspend for the host controller
>
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>> For some scenarios, it may send many IOs in a short time, then SAS 
>> controller
>> will enter suspend and resume frequently which is invalid.
>> To avoid it, use autosuspend mode for SAS controller and set default
>> autosuspend delay time to 5s.
>
> The controller may frequently enter and exit suspend for each IO which 
> we need to deal with. This is inefficient and may cause too much 
> suspend+resume activity for the controller.
>
> To avoid this, use a default 5s autosuspend for the controller to stop 
> frequently suspending and resuming. This value may still be still 
> modified via sysfs.
>
>>
>> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>
> Acked-by please

ok

>
> Thanks,
> John
>
> .
>


