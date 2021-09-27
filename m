Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9B5DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9126F60F70
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 09:38:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbhI0Jjy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 05:39:54 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3879 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhI0Jjx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 05:39:53 -0400
Received: from fraeml701-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HHyDZ3Xlmz67Dcf;
        Mon, 27 Sep 2021 17:35:42 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml701-chm.china.huawei.com (10.206.15.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 27 Sep 2021 11:38:13 +0200
Received: from [10.47.85.67] (10.47.85.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 27 Sep
 2021 10:38:13 +0100
Subject: Re: [PATCH v4 12/13] blk-mq: Use shared tags for shared sbitmap
 support
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <hare@suse.de>
References: <1632472110-244938-1-git-send-email-john.garry@huawei.com>
 <1632472110-244938-13-git-send-email-john.garry@huawei.com>
 <YU/oIu2uQ420ol8F@T590> <6f52adfd-6904-6efb-adfc-f5f20eb5c1cf@huawei.com>
 <YVGORkQuf2FQmxwN@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a89ae671-c455-1b05-d140-82d4a90507f6@huawei.com>
Date:   Mon, 27 Sep 2021 10:41:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <YVGORkQuf2FQmxwN@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.67]
X-ClientProxiedBy: lhreml717-chm.china.huawei.com (10.201.108.68) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/09/2021 10:26, Ming Lei wrote:
>>>> -	struct sbitmap_queue	sched_bitmap_tags;
>>>> -	struct sbitmap_queue	sched_breserved_tags;
>>>> +	struct blk_mq_tags	*shared_sbitmap_tags;
>>> Maybe better with shared_sched_sbitmap_tags or sched_sbitmap_tags?
>> Yeah, I suppose I should add "sched" to the name, as before.
>>
>> BTW, Do you think that I should just change shared_sbitmap -> shared_tags
>> naming now globally? I'm thinking now that I should...
> Yeah, I think so, but seems you preferred to the name of shared sbitmap, so I
> did't mention that,:-)

OK, I can clear up any references in a follow on patch to try to keep 
this one as small as possible.

Thanks,
John
