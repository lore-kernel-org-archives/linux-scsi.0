Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E5DC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 02:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbiLUCuv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Dec 2022 21:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiLUCus (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Dec 2022 21:50:48 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E402734;
        Tue, 20 Dec 2022 18:50:47 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NcHwH1TRyzRq7G;
        Wed, 21 Dec 2022 10:49:35 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 21 Dec 2022 10:50:45 +0800
Subject: Re: [PATCH v2] scsi: libsas: Fix did not grab the ata port lock in
 sas_ata_device_link_abort()
To:     Xingui Yang <yangxingui@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <john.g.garry@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
        <kangfenglong@huawei.com>
References: <20221221015203.46367-1-yangxingui@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <c75ffece-15d4-37c6-b09c-8032f0a21d77@huawei.com>
Date:   Wed, 21 Dec 2022 10:50:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20221221015203.46367-1-yangxingui@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/21 9:52, Xingui Yang wrote:
> Grab the ata port lock in sas_ata_device_link_abort() before calling
> ata_link_abort(), as the comment in ata_link_abort() mentions.
> 
> Fixes: 44112922674b ("scsi: libsas: Add sas_ata_device_link_abort()")
> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
> Changes to v1:
> - Add a fixes tag
> - Update commit message
> ---
>   drivers/scsi/libsas/sas_ata.c | 3 +++
>   1 file changed, 3 insertions(+)

Looks good,
Reviewed-by: Jason Yan <yanaijie@huawei.com>
