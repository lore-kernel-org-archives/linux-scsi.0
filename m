Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE8CFC43466
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 16:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2A14206F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 16:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGVQBd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jul 2020 12:01:33 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2511 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726539AbgGVQBd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jul 2020 12:01:33 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 14CB3C3C5170507FA51;
        Wed, 22 Jul 2020 17:01:31 +0100 (IST)
Received: from [127.0.0.1] (10.47.1.221) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 22 Jul
 2020 17:01:30 +0100
Subject: Re: [PATCH] scsi: libsas: remove redundant assignment to variable res
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200722154404.959267-1-colin.king@canonical.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ae1d58d3-3dac-14c2-9e10-047ffcbe8c99@huawei.com>
Date:   Wed, 22 Jul 2020 16:59:36 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200722154404.959267-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.1.221]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/07/2020 16:44, Colin King wrote:
> From: Colin Ian King<colin.king@canonical.com>
> 
> The variable res is being initialized with a value that is
> never read and it is being updated later with a new value. The
> initialization is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King<colin.king@canonical.com>

Reviewed-by: John Garry <john.garry@huawei.com>
