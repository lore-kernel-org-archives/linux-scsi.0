Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C546EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A98A161212
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhIOHcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 03:32:16 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3809 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbhIOHcQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 03:32:16 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H8Wzd3byrz67xbc;
        Wed, 15 Sep 2021 15:28:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 15 Sep 2021 09:30:56 +0200
Received: from [10.47.80.114] (10.47.80.114) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Wed, 15 Sep
 2021 08:30:55 +0100
Subject: Re: [PATCH 0/4] scsi: remove last references to scsi_cmnd.tag
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        "James Bottomley" <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20210819084007.79233-1-hare@suse.de>
 <ef629eef-fe55-2c8b-2825-67c43e4f4cd8@huawei.com>
 <yq17dfiwmky.fsf@ca-mkp.ca.oracle.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <19dae8d5-dfa4-bcdc-322f-4445f26321c7@huawei.com>
Date:   Wed, 15 Sep 2021 08:34:31 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <yq17dfiwmky.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.114]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 15/09/2021 04:21, Martin K. Petersen wrote:
>> The arm rpc_defconfig build is now broken on mainline.
>>
>> I suggest resending this series, please.
> Yes, please!

I'm going to just do that now.
