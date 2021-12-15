Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E93F2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Dec 2021 07:34:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240578AbhLOHei (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Dec 2021 02:34:38 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:28319 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240552AbhLOHei (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Dec 2021 02:34:38 -0500
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JDRp303G2zbjVj;
        Wed, 15 Dec 2021 15:34:19 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.20; Wed, 15
 Dec 2021 15:34:36 +0800
Subject: Re: [PATCH 10/15] scsi: libsas: Add a flag SAS_HA_RESUMING of sas_ha
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-11-git-send-email-chenxiang66@hisilicon.com>
 <6d34c9a6-cf2f-81ee-6056-969b3d505c2f@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <db8994fc-41c0-ec46-cf4e-894ca4923c9e@hisilicon.com>
Date:   Wed, 15 Dec 2021 15:34:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <6d34c9a6-cf2f-81ee-6056-969b3d505c2f@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



在 2021/12/13 19:17, John Garry 写道:
> On 17/11/2021 02:45, chenxiang wrote:
>
> I'd just have "scsi: libsas: Add flag SAS_HA_RESUMING"

Ok

>
>> From: Xiang Chen<chenxiang66@hisilicon.com>
>>
>> Add a flag SAS_HA_RESUMING and use it to indicate the process of 
>> resuming
>> sas_ha.
>
> Add a flag SAS_HA_RESUMING and use it to indicate the state of 
> resuming the host controller.
Ok
>
>>
>> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
>> Reviewed-by: John Garry<john.garry@huawei.com>
>
>
> .
>


