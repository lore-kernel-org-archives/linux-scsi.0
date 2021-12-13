Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAEAC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 11:17:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhLMLRe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Dec 2021 06:17:34 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4260 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhLMLR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Dec 2021 06:17:29 -0500
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCJp44BQbz67N8d;
        Mon, 13 Dec 2021 19:15:24 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 12:17:26 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 13 Dec
 2021 11:17:26 +0000
Subject: Re: [PATCH 10/15] scsi: libsas: Add a flag SAS_HA_RESUMING of sas_ha
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
 <1637117108-230103-11-git-send-email-chenxiang66@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6d34c9a6-cf2f-81ee-6056-969b3d505c2f@huawei.com>
Date:   Mon, 13 Dec 2021 11:17:06 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-11-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.94]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/11/2021 02:45, chenxiang wrote:

I'd just have "scsi: libsas: Add flag SAS_HA_RESUMING"

> From: Xiang Chen<chenxiang66@hisilicon.com>
> 
> Add a flag SAS_HA_RESUMING and use it to indicate the process of resuming
> sas_ha.

Add a flag SAS_HA_RESUMING and use it to indicate the state of resuming 
the host controller.

> 
> Signed-off-by: Xiang Chen<chenxiang66@hisilicon.com>
> Reviewed-by: John Garry<john.garry@huawei.com>

