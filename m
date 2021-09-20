Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02458C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 16:44:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAB7A61177
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 16:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhITQqG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 12:46:06 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3847 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbhITQqF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 12:46:05 -0400
Received: from fraeml735-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HCr1y4Bqyz67l0D;
        Tue, 21 Sep 2021 00:42:14 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml735-chm.china.huawei.com (10.206.15.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 20 Sep 2021 18:44:36 +0200
Received: from [10.47.88.85] (10.47.88.85) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 20 Sep
 2021 17:44:36 +0100
Subject: Re: [PATCH 02/84] scsi: core: Rename scsi_mq_done() into scsi_done()
 and export it
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-3-bvanassche@acm.org>
 <ee1a1197-1fd1-e9d9-6b45-79108d56830b@huawei.com>
 <36171806-8c85-654d-1f7d-3d19fc7227c9@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <07d66ceb-797e-50fc-3a29-14757cbb2855@huawei.com>
Date:   Mon, 20 Sep 2021 17:47:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <36171806-8c85-654d-1f7d-3d19fc7227c9@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.85]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 20/09/2021 17:28, Bart Van Assche wrote:
>>
>> I have gone to the end of the series, and we still set 
>> scsi_cmnd.scsi_done. So some drivers still rely on it. I thought that 
>> the idea was that we don't need this callback pointer any longer.
> 
> It seems like the email service I used to send out the patches (gmail)
> dropped patches 79/84..84/84. The entire patch series is available here:
> https://github.com/bvanassche/linux/tree/scsi-remove-done-callback

Hi Bart,

ok, I see. b4 am only picked up to 78/84 for me. If you resend, then I 
can check again any changes to code which I may be familiar with.

Thanks,
John
