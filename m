Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E409C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 14 May 2022 09:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiENJtq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 May 2022 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbiENJtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 May 2022 05:49:45 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D074F441;
        Sat, 14 May 2022 02:49:23 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L0gZx14z1z67Xmk;
        Sat, 14 May 2022 17:44:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 14 May 2022 11:49:20 +0200
Received: from [10.47.26.143] (10.47.26.143) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2375.24; Sat, 14 May
 2022 10:49:19 +0100
Message-ID: <0f274df2-e7e2-bfca-14b5-631fe78fc6da@huawei.com>
Date:   Sat, 14 May 2022 10:49:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [bug report] IOMMU reports data translation fault for fio testing
To:     Bart Van Assche <bvanassche@acm.org>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     "chenxiang66@hisilicon.com >> Xiang Chen" <chenxiang66@hisilicon.com>,
        "liyihang (E)" <liyihang6@hisilicon.com>
References: <2b7d091b-4caf-948f-b41a-29a7fcb9fc2a@huawei.com>
 <f5739f11-f07c-3bfe-451a-6d7a24550e61@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <f5739f11-f07c-3bfe-451a-6d7a24550e61@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.26.143]
X-ClientProxiedBy: lhreml704-chm.china.huawei.com (10.201.108.53) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/05/2022 03:28, Bart Van Assche wrote:
> On 5/13/22 05:01, John Garry wrote:
>> It could be an issue with the SCSI hba driver.
> 
> That seems likely to me.

Sure, that would be common wisdom. However the commit before anything 
related to driver was added for 5.18 is also bad. It could be 
pre-existing, but that starts to seem unlikely. Or it could still be an 
IOMMU issue - we already have a performance issue there.

This issue can take more than 15 minutes to occur, so is pretty painful 
to bisect...

Thanks,
John


