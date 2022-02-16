Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F802C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Feb 2022 11:38:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbiBPLjI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Feb 2022 06:39:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiBPLjH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Feb 2022 06:39:07 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0391207FEF
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 03:38:55 -0800 (PST)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JzGD80xslz67pbm;
        Wed, 16 Feb 2022 19:38:00 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 16 Feb 2022 12:38:53 +0100
Received: from [10.47.81.42] (10.47.81.42) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Wed, 16 Feb
 2022 11:38:52 +0000
Message-ID: <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
Date:   Wed, 16 Feb 2022 11:38:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.42]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/02/2022 11:36, Damien Le Moal wrote:
> On 2/15/22 19:55, John Garry wrote:
>> On 14/02/2022 02:17, Damien Le Moal wrote:
>>> Avoid repeatedly declaring "struct task_status_struct *ts" to handle
>>> error cases by declaring this variable for the entire function scope.
>>> This allows simplifying the error cases, and together with the addition
>>> of blank lines make the code more readable.
>>>
>>> Reviewed-by: John Garry<john.garry@huawei.com>
>>> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
>>> ---
>>
>> I assume that this can now just be merged with 30/31
> 

Hi Damien,

> patch 30 cleans up pm8001_task_exec(). This patch is for
> pm8001_queue_command(). I preferred to separate to facilitate review.
> But if you insist, I can merge these into a much bigger "code cleanup"
> patch...
> 
I don't mind really.

BTW, on a separate topic, IIRC you said that rmmod hangs for this driver 
- if so, did you investigate why?

Thanks,
John
