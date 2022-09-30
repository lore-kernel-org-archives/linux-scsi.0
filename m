Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19271C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 09:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiI3JXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Sep 2022 05:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiI3JXB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Sep 2022 05:23:01 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF194156C04;
        Fri, 30 Sep 2022 02:23:00 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Mf4Sc6rWxzpVGT;
        Fri, 30 Sep 2022 17:20:00 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 30 Sep 2022 17:22:58 +0800
Subject: Re: [PATCH v2 1/6] scsi: libsas: Add sas_task_find_rq()
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@wdc.com>
CC:     <hare@suse.de>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <ipylypiv@google.com>, <changyuanl@google.com>, <hch@lst.de>
References: <1664528184-162714-1-git-send-email-john.garry@huawei.com>
 <1664528184-162714-2-git-send-email-john.garry@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <9c5e2261-cd65-5d4e-a384-fa78042947de@huawei.com>
Date:   Fri, 30 Sep 2022 17:22:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1664528184-162714-2-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/9/30 16:56, John Garry wrote:
> blk-mq already provides a unique tag per request. Some libsas LLDDs - like
> hisi_sas - already use this tag as the unique per-IO HW tag.
> 
> Add a common function to provide the request associated with a sas_task
> for all libsas LLDDs.
> 
> Signed-off-by: John Garry<john.garry@huawei.com>
> ---
>   include/scsi/libsas.h | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
