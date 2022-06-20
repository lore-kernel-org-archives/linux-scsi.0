Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC0CECCA481
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 11:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241670AbiFTLOn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 07:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241874AbiFTLO1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 07:14:27 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D562175A9;
        Mon, 20 Jun 2022 04:13:17 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LRRlt2yjBz6H6lq;
        Mon, 20 Jun 2022 19:11:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Mon, 20 Jun 2022 13:12:58 +0200
Received: from [10.195.35.72] (10.195.35.72) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 20 Jun
 2022 12:12:57 +0100
Message-ID: <b98ad03b-e599-6023-3b34-ebefb590bf8c@huawei.com>
Date:   Mon, 20 Jun 2022 12:12:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 5/5] blk-mq: Drop 'reserved' member of busy_tag_iter_fn
To:     Bart Van Assche <bvanassche@acm.org>, <axboe@kernel.dk>,
        <damien.lemoal@opensource.wdc.com>, <hch@lst.de>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>, <hare@suse.de>,
        <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>
CC:     <linux-rdma@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <linux-nvme@lists.infradead.org>, <linux-s390@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <mpi3mr-linuxdrv.pdl@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nbd@other.debian.org>
References: <1655463320-241202-1-git-send-email-john.garry@huawei.com>
 <1655463320-241202-6-git-send-email-john.garry@huawei.com>
 <017cae1e-b45f-04fd-d34c-22ae736b28e5@acm.org>
 <a18fa379-5a9b-ff45-3be4-b253efd96a50@huawei.com>
 <c6a0eb8d-ad51-01b1-bc17-758acc37f216@acm.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <c6a0eb8d-ad51-01b1-bc17-758acc37f216@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.195.35.72]
X-ClientProxiedBy: lhreml744-chm.china.huawei.com (10.201.108.194) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/06/2022 17:55, Bart Van Assche wrote:
>>
>> It's not totally necessary. Since local variable 'reserved' would now 
>> only be used once I thought it was better to get rid of it.
>>
>> I can keep it if you really think that is better.
> 
> I'd prefer that these changes are either left out or that these are 
> moved into a separate patch. I think that will make this patch series 
> easier to review.

Personally I think that this is a trivial change and does not merit a 
separate patch. Other reviewers seem to agree. Anyway, if you feel 
strongly about this then I can put in another patch.

Thanks,
John
