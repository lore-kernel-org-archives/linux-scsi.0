Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67249C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Feb 2022 08:03:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233362AbiBOIDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Feb 2022 03:03:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231487AbiBOIDk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Feb 2022 03:03:40 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B7A26574;
        Tue, 15 Feb 2022 00:03:29 -0800 (PST)
Received: from fraeml744-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyYVf56Pvz6F92f;
        Tue, 15 Feb 2022 16:03:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml744-chm.china.huawei.com (10.206.15.225) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 09:03:28 +0100
Received: from [10.47.81.62] (10.47.81.62) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.21; Tue, 15 Feb
 2022 08:03:27 +0000
Message-ID: <a756b22a-5eb5-a883-c9ca-c2345493dee7@huawei.com>
Date:   Tue, 15 Feb 2022 08:03:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH -next] scsi: hisi_sas: Remove unnecessary print function
 dev_err()
To:     Yang Li <yang.lee@linux.alibaba.com>, <jejb@linux.ibm.com>
CC:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Abaci Robot <abaci@linux.alibaba.com>
References: <20220215020524.44268-1-yang.lee@linux.alibaba.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220215020524.44268-1-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.81.62]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/02/2022 02:05, Yang Li wrote:
> The print function dev_err() is redundant because platform_get_irq()
> already prints an error.
> 
> Eliminate the follow coccicheck warnings:
> ./drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1661:3-10: line 1661 is
> redundant because platform_get_irq() already prints an error
> ./drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1642:4-11: line 1642 is
> redundant because platform_get_irq() already prints an error
> ./drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1679:3-10: line 1679 is
> redundant because platform_get_irq() already prints an error
> 
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> Signed-off-by: Yang Li<yang.lee@linux.alibaba.com>

Acked-by: John Garry <john.garry@huawei.com>
