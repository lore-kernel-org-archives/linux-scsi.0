Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC31FC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 09:10:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348119AbiBKJKW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 04:10:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240018AbiBKJKU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 04:10:20 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0930DF5F
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 01:10:18 -0800 (PST)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jw7964X5wz67k2V;
        Fri, 11 Feb 2022 17:09:30 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 10:10:16 +0100
Received: from [10.47.86.199] (10.47.86.199) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Feb
 2022 09:10:15 +0000
Message-ID: <12a7a42d-11e8-1b5b-a64c-c91ab1d13c28@huawei.com>
Date:   Fri, 11 Feb 2022 09:10:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 4/4] scsi: Remove unused member cmd_pool for structure
 scsi_host_template
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.vnet.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linuxarm@huawei.com>, <linux-scsi@vger.kernel.org>
References: <1644561778-183074-1-git-send-email-chenxiang66@hisilicon.com>
 <1644561778-183074-5-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <1644561778-183074-5-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.199]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/02/2022 06:42, chenxiang wrote:
> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> After the commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as
> part of struct request"), the member cmd_pool in structure
> scsi_host_template is not used, so remove it.
> 
> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
> ---

Reviewed-by: John Garry <john.garry@huawei.com>
