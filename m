Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F26AC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 11:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 100146135F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 11:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346107AbhESLZ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 07:25:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4682 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240028AbhESLZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 07:25:53 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FlVnQ1gqvz1BPBk;
        Wed, 19 May 2021 19:21:46 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 19:24:31 +0800
Received: from [10.47.87.246] (10.47.87.246) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 19 May
 2021 12:24:29 +0100
Subject: Re: [PATCH v2 2/3] Introduce enums for the SAM, message, host and
 driver status codes
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210518175006.21308-1-bvanassche@acm.org>
 <20210518175006.21308-3-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <71783cd3-b008-f5c9-b5a0-8c4279b2d017@huawei.com>
Date:   Wed, 19 May 2021 12:23:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210518175006.21308-3-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.246]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/05/2021 18:50, Bart Van Assche wrote:
> Make it possible for the compiler to verify whether SAM, message, host
> and driver status codes are used correctly.
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Changing to enums seems a sensible change, so, FWIW:
Reviewed-by: John Garry <john.garry@huawei.com>

Do we have an example of where the compiler would catch an incorrect 
usage / mismatch?
