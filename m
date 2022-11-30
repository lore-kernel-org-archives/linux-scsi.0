Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D380C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 14:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiK3OKu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 09:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiK3OKV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 09:10:21 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DE7920AF
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 06:08:33 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4NMgyb3F0Vz15N0t;
        Wed, 30 Nov 2022 22:07:51 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 30 Nov 2022 22:08:31 +0800
Subject: Re: [PATCH v5] scsi: sd_zbc: trace zone append emulation
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
References: <d103bcf5f90139143469f2a0084c74bd9e03ad4a.1669804487.git.johannes.thumshirn@wdc.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <df858d8a-cdf5-d740-eda1-0c233bf6ce07@huawei.com>
Date:   Wed, 30 Nov 2022 22:08:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <d103bcf5f90139143469f2a0084c74bd9e03ad4a.1669804487.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/11/30 18:36, Johannes Thumshirn wrote:
> Add tracepoints to the SCSI zone append emulation, in order to trace the
> zone start to write-pointer aligned LBA translation and the corresponding
> completion.
> 
> Signed-off-by: Johannes Thumshirn<johannes.thumshirn@wdc.com>
> 
> ---
> Changes to v4:
> - Move tracepoint header to drivers/scsi
> 
> Changes to v3:
> - Move tracepoints into own sd trace events header
> 
> Changes to v2:
> - Fix linking when SCSI is a module
> 
> Changes to v1:
> - Fix style issues pointed out by Damien
> ---
>   drivers/scsi/sd_trace.h | 85 +++++++++++++++++++++++++++++++++++++++++
>   drivers/scsi/sd_zbc.c   |  6 +++
>   2 files changed, 91 insertions(+)
>   create mode 100644 drivers/scsi/sd_trace.h

Looks good,
Reviewed-by: Jason Yan <yanaijie@huawei.com>
