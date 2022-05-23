Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46D01C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 May 2022 12:00:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235222AbiEWMAO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 May 2022 08:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235029AbiEWMAN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 May 2022 08:00:13 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C6F52526;
        Mon, 23 May 2022 05:00:11 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L6G4n5HfQz67xMg;
        Mon, 23 May 2022 19:56:09 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 23 May 2022 14:00:09 +0200
Received: from [10.47.87.6] (10.47.87.6) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 23 May
 2022 13:00:08 +0100
Message-ID: <b756a30e-9fb1-ad0e-a55d-3fd3354b8517@huawei.com>
Date:   Mon, 23 May 2022 13:00:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 0/4] DMA mapping changes for SCSI core
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>
CC:     <joro@8bytes.org>, <will@kernel.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <m.szyprowski@samsung.com>,
        <robin.murphy@arm.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <linux-scsi@vger.kernel.org>,
        <liyihang6@hisilicon.com>, <chenxiang66@hisilicon.com>,
        <thunder.leizhen@huawei.com>
References: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
 <20220522131345.GB25785@lst.de>
 <15f94ea2-fa97-3122-60dd-a87a3dd8a7db@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <15f94ea2-fa97-3122-60dd-a87a3dd8a7db@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.6]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/05/2022 23:22, Damien Le Moal wrote:
> On 2022/05/22 22:13, Christoph Hellwig wrote:
>> The whole series looks fine to me.  I'll happily queue it up in the
>> dma-mapping tree if the SCSI and ATA maintainers are ok with that.
>>
> 
> Fine with me. I sent an acked-by for the libata bit.
> 

Thanks, I'm going to have to post a v2 and I figure that with the timing 
that I'll have to wait for v5.20 now.

Cheers,
John
