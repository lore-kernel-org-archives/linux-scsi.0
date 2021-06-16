Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC07DC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 09:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B9061359
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 09:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbhFPJoI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 05:44:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7458 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbhFPJoH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 05:44:07 -0400
Received: from dggeme756-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G4g9v4KHLzZhjg;
        Wed, 16 Jun 2021 17:38:59 +0800 (CST)
Received: from [127.0.0.1] (10.40.193.166) by dggeme756-chm.china.huawei.com
 (10.3.19.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 16
 Jun 2021 17:41:54 +0800
Subject: Re: remove ->revalidate_disk (resend)
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tim Waugh <tim@cyberelk.net>, <martin.petersen@oracle.com>
References: <20210308074550.422714-1-hch@lst.de>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
From:   "chenxiang (M)" <chenxiang66@hisilicon.com>
Message-ID: <96011dbd-084f-8a07-3506-fc7717122866@hisilicon.com>
Date:   Wed, 16 Jun 2021 17:41:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20210308074550.422714-1-hch@lst.de>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.40.193.166]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeme756-chm.china.huawei.com (10.3.19.102)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Before i reported a issue related to revalidate disk 
(https://www.spinics.net/lists/linux-scsi/msg151610.html), and no one 
replies, but the issue is still.

And i plan to resend it, but i find that revalidate_disk interface is 
completely removed in this patchset.

Do you have any idea about the above issue?

ÔÚ 2021/3/8 15:45, Christoph Hellwig Ð´µÀ:
> Hi Jens,
>
> with the previously merged patches all real users of ->revalidate_disk
> are gone.  This series removes the two remaining not actually required
> instances and the method itself.
>
> .
>


