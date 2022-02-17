Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5E4C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 17:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242733AbiBQRnK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 12:43:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbiBQRnK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 12:43:10 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F381A2768
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 09:42:55 -0800 (PST)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K02Ff6KHLz67yc1;
        Fri, 18 Feb 2022 01:41:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 18:42:53 +0100
Received: from [10.47.86.67] (10.47.86.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Feb
 2022 17:42:53 +0000
Message-ID: <a7d796d5-40c6-608d-abbe-28bd517a08a2@huawei.com>
Date:   Thu, 17 Feb 2022 17:42:52 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v4 21/31] scsi: pm8001: Fix task leak in
 pm8001_send_abort_all()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com>
 <20220217132956.484818-22-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220217132956.484818-22-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.67]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/02/2022 13:29, Damien Le Moal wrote:
> In pm8001_send_abort_all(), make sure to free the allocated sas task
> if pm8001_tag_alloc() or pm8001_mpi_build_cmd() fail.
> 
> Signed-off-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>

Reviewed-by: John Garry <john.garry@huawei.com>
