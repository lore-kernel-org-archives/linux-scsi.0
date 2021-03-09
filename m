Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8657EC433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 14:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D48D651C7
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 14:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCIOHt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 09:07:49 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2669 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbhCIOHW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 09:07:22 -0500
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DvxkB2PMyz67xPg;
        Tue,  9 Mar 2021 22:02:58 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 15:07:20 +0100
Received: from [10.210.172.22] (10.210.172.22) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 14:07:19 +0000
Subject: Re: [PATCH 26/31] scsi: libsas,hisi_sas,mvsas,pm8001: Allocate
 Scsi_cmd for slow task
To:     luojiaxing <luojiaxing@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>
References: <20210222132405.91369-1-hare@suse.de>
 <20210222132405.91369-27-hare@suse.de>
 <9387eb39-b457-177a-c271-837641d19691@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b3725d65-8c9d-6007-1180-38a121372dce@huawei.com>
Date:   Tue, 9 Mar 2021 14:05:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <9387eb39-b457-177a-c271-837641d19691@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.172.22]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/03/2021 11:22, luojiaxing wrote:
> Hi, Hannes, john
> 
> 
> I found some tiny coding issues of this patch. check below.
> 
> And if someone else have already point out, please ignore.
> 

JFYI, I have put the patches on this following branch, and fixed up to 
get building+working:
https://github.com/hisilicon/kernel-dev/commits/private-topic-sas-5.11-resv7

Thanks,
John

> 
> On 2021/2/22 21:24, Hannes Reinecke wrote:
>> From: John Garry <john.garry@huawei.com>

