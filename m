Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4ADC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240513AbhLOH0J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:26:09 -0500
Received: from szxga03-in.huawei.com ([45.249.212.189]:29197 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbhLOH0J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:26:09 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4JDRZ31R4lz8vv7;
        Wed, 15 Dec 2021 15:23:55 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:26:07 +0800
Subject: Re: [PATCH 08/15] scsi: hisi_sas: Add more prink for runtime
 suspend/resume
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-9-git-send-email-chenxiang66@hisilicon.com>
 <e65ff597-c75f-21fd-c9f3-311a5261e789@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <40d3eaee-2f12-a298-5770-63ea8c6ba82e@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:26:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <e65ff597-c75f-21fd-c9f3-311a5261e789@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 18:34, John Garry 写道:
> On 17/11/2021 02:45, chenxiang wrote:
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>> Add some prink at the beginning and end of suspend/resume.
>>
>
> Same as subject, it should be /s/prink/logs or prints/. I assume.

ok, i will use logs instead

>
>
>> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>
>
> .
>


