Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E11DC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 01:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240597AbiGTBrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 21:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbiGTBrH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 21:47:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6DC205CB;
        Tue, 19 Jul 2022 18:47:06 -0700 (PDT)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LndmV6GqWzkXB1;
        Wed, 20 Jul 2022 09:44:42 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 20 Jul 2022 09:47:04 +0800
Subject: Re: [PATCH] scsi: fix WARNING in scsi_alloc_sgtables
To:     Bart Van Assche <bvanassche@acm.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <hare@suse.com>, <hch@lst.de>,
        <syzbot+d44b35ecfb807e5af0b5@syzkaller.appspotmail.com>
References: <20220719080026.1595874-1-yanaijie@huawei.com>
 <2f0cba61-b98a-9b14-6bb5-700f2b367e3b@acm.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <88082ab3-0a2b-9175-eb7d-8472d3ff9430@huawei.com>
Date:   Wed, 20 Jul 2022 09:47:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2f0cba61-b98a-9b14-6bb5-700f2b367e3b@acm.org>
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


On 2022/7/20 2:08, Bart Van Assche wrote:
> On 7/19/22 01:00, Jason Yan wrote:
>> When iovec_count is non-zero and dxfer_len is zero, the sg_io() just
>> genarated a null bio, and finally caused a warning below. To fix it,
>> skip generating a bio for this request if dxfer_len is zero.
> 
> Since this patch is a bug fix, I think it needs a Fixes: tag.
> 

Thanks Bart. I will dig it out and send v2.

> Thanks,
> 
> Bart.
> .
