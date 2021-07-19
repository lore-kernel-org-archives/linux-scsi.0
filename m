Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D4AC12002
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 08:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5FD561181
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Jul 2021 08:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhGSINb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Jul 2021 04:13:31 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3428 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234954AbhGSINb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jul 2021 04:13:31 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GSvPQ3qrTz6J75C;
        Mon, 19 Jul 2021 15:59:06 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 19 Jul 2021 10:10:30 +0200
Received: from [10.47.85.214] (10.47.85.214) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 19 Jul
 2021 09:10:29 +0100
Subject: Re: [PATCH] scsi: libsas: allow libsas include scsi header files
 directly
To:     yanaijie <yanaijie@huawei.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20210716074551.771312-1-yanaijie@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <20b8863e-03ab-165e-3525-cc2e6a10c6b1@huawei.com>
Date:   Mon, 19 Jul 2021 09:10:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210716074551.771312-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.85.214]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/07/2021 08:45, yanaijie wrote:
> libsas needs to include some header files in the scsi directory. However
> they are now hardcoded with the path "../" in the C files. Let's do this
> in the Makefile to avoid the hardcode.
> 
> Cc: John Garry<john.garry@huawei.com>
> Signed-off-by: Jason Yan<yanaijie@huawei.com>
> ---
>   drivers/scsi/libsas/Makefile        | 2 +-
>   drivers/scsi/libsas/sas_ata.c       | 4 ++--
>   drivers/scsi/libsas/sas_discover.c  | 2 +-
>   drivers/scsi/libsas/sas_expander.c  | 2 +-
>   drivers/scsi/libsas/sas_host_smp.c  | 2 +-
>   drivers/scsi/libsas/sas_init.c      | 2 +-
>   drivers/scsi/libsas/sas_phy.c       | 2 +-
>   drivers/scsi/libsas/sas_port.c      | 2 +-
>   drivers/scsi/libsas/sas_scsi_host.c | 6 +++---
>   9 files changed, 12 insertions(+), 12 deletions(-)

Reviewed-by: John Garry <john.garry@huawei.com>
