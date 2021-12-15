Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB6B4C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240496AbhLOHUY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:20:24 -0500
Received: from szxga08-in.huawei.com ([45.249.212.255]:29132 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233441AbhLOHUY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:20:24 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4JDRQV6JX2z1DK6r;
        Wed, 15 Dec 2021 15:17:22 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:20:22 +0800
Subject: Re: [PATCH 02/15] Revert "scsi: hisi_sas: Filter out new PHY up
 events during suspend"
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-3-git-send-email-chenxiang66@hisilicon.com>
 <b39e2873-9b2d-8eaa-ad69-617aa047aef7@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <64a18d77-289a-8d9d-50a7-8696cf5e28ee@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:20:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <b39e2873-9b2d-8eaa-ad69-617aa047aef7@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 18:31, John Garry 写道:
> On 17/11/2021 02:44, chenxiang wrote:
>> From: John Garry<john.garry@huawei.com>
>>
>> This reverts commit b14a37e011d829404c29a5ae17849d7efb034893.
>>
>> In that commit, we had to filter out phy-up events during suspend, as it
>> work cause a deadlock between processing the phyup event and the resume
>> HA function try to drain the HA event workqueue to complete the resume
>> process.
>>
>> Now that we no longer try to drain the HA event queue during the HA
>> resume processor, the deadlock would not occur, so remove the special
>> handling for it.
>>
>> Signed-off-by: John Garry<john.garry@huawei.com>
>
> This is missing your Signed-off-by

Ok, i will add it in next version.

>
> Thanks,
> John
>
> .
>


