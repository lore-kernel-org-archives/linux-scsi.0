Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D886FC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 07:52:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7717613D0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 07:52:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234947AbhHXHvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 03:51:00 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3680 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234616AbhHXHu7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Aug 2021 03:50:59 -0400
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Gv1T534fTz67m29;
        Tue, 24 Aug 2021 15:48:57 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 24 Aug 2021 09:50:12 +0200
Received: from [10.47.87.96] (10.47.87.96) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 24 Aug
 2021 08:50:11 +0100
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <satishkh@cisco.com>, <sebaddel@cisco.com>, <jejb@linux.ibm.com>,
        <kartilak@cisco.com>
CC:     <linux-kernel@vger.kernel.org>, <bvanassche@acm.org>,
        <linux-scsi@vger.kernel.org>, <hch@lst.de>, <hare@suse.de>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <162977310549.31461.5518262804247567380.b4-ty@oracle.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <2bdc7756-52bb-9b5d-045d-4d8302c52c63@huawei.com>
Date:   Tue, 24 Aug 2021 08:54:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <162977310549.31461.5518262804247567380.b4-ty@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.96]
X-ClientProxiedBy: lhreml719-chm.china.huawei.com (10.201.108.70) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/08/2021 05:03, Martin K. Petersen wrote:
> On Fri, 13 Aug 2021 21:49:10 +0800, John Garry wrote:
> 
>> There is no need for scsi_cmnd.tag, so remove it.
>>
>> Based on next-20210811
>>
>> John Garry (3):
>>    scsi: wd719: Stop using scsi_cmnd.tag
>>    scsi: fnic: Stop setting scsi_cmnd.tag
>>    scsi: Remove scsi_cmnd.tag
>>
>> [...]
> 
> Applied to 5.15/scsi-queue, thanks!
> 
> [1/3] scsi: wd719: Stop using scsi_cmnd.tag
>        https://git.kernel.org/mkp/scsi/c/e2a1dc571e19
> [2/3] scsi: fnic: Stop setting scsi_cmnd.tag
>        https://git.kernel.org/mkp/scsi/c/e0aebd25fdd9
> [3/3] scsi: Remove scsi_cmnd.tag
>        https://git.kernel.org/mkp/scsi/c/4c7b6ea336c1
> 

Thanks, but we still have the issue with the arm drivers.

I'll ping Russell again if he doesn't reply soon.

Hannes also sent a series - that may be the way forward, but need 
Russell involved.

John
