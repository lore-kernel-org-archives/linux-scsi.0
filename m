Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E92DC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 08:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC68564D74
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 08:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhBXI6G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 03:58:06 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2600 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbhBXI6F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 03:58:05 -0500
Received: from fraeml703-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DlqSx4TY5z67rXK;
        Wed, 24 Feb 2021 16:53:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml703-chm.china.huawei.com (10.206.15.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Wed, 24 Feb 2021 09:57:23 +0100
Received: from [10.47.10.98] (10.47.10.98) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Wed, 24 Feb
 2021 08:57:22 +0000
Subject: Re: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        "Viswas.G@microchip.com" <Viswas.G@microchip.com>
References: <20210222132405.91369-1-hare@suse.de>
 <a6234ede-74bd-81f0-9d39-db398b79f50a@huawei.com>
 <6d2f5677-b033-9639-82da-655152ad6d8c@huawei.com>
 <ca83b2b4-8266-17f6-cf08-2673d1fa0881@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <91ee705f-3d56-7d8f-05db-9dc063286d96@huawei.com>
Date:   Wed, 24 Feb 2021 08:55:35 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <ca83b2b4-8266-17f6-cf08-2673d1fa0881@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.10.98]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2021 06:54, Hannes Reinecke wrote:
>>
>> So I got this working eventually for hisi_sas - a few fixes needed:
>> https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.11-resv7 
>>
>>
>> I'll have a look at the core patches tomorrow. However, at this point, 
>> how about convert just a couple of drivers (the ones which you can 
>> test) to get it merged as a start? 31 patches is too many.
>>
> Yeah, I know. Actually, I just sent it out so that you can have a look 
> at my libsas slow task rework.
> 

Fine, but obviously that libsas and users stuff needs more work.

> But I can easily split it off for just fnic/snic/aacraid/hpsa, and leave 
> the libsas slow task stuff for the next round.

I think that's better. But even then, it's still a large patchset. Maybe 
1 or 2 drivers is enough to start with... and whatever you can test, as 
I don't have HW to test those.

Thanks,
John

