Return-Path: <SRS0=msWv=XS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96E08C4740C
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 08:33:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75DDD2087C
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 08:33:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406140AbfIWIdo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 04:33:44 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2768 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405465AbfIWIdn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Sep 2019 04:33:43 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E964F59327526B9B919C;
        Mon, 23 Sep 2019 16:33:41 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.179) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.439.0; Mon, 23 Sep 2019
 16:33:34 +0800
Subject: Re: [PATCH -next] scsi: hisi_sas: Make three functions static
To:     YueHaibing <yuehaibing@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
References: <20190923054035.19036-1-yuehaibing@huawei.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4d46c4c8-6827-c73d-c6d1-ed022f0e498b@huawei.com>
Date:   Mon, 23 Sep 2019 09:33:30 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <20190923054035.19036-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.179]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/09/2019 06:40, YueHaibing wrote:
> Fix sparse warnings:
>
> drivers/scsi/hisi_sas/hisi_sas_main.c:3686:6:
>  warning: symbol 'hisi_sas_debugfs_release' was not declared. Should it be static?
> drivers/scsi/hisi_sas/hisi_sas_main.c:3708:5:
>  warning: symbol 'hisi_sas_debugfs_alloc' was not declared. Should it be static?
> drivers/scsi/hisi_sas/hisi_sas_main.c:3799:6:
>  warning: symbol 'hisi_sas_debugfs_bist_init' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Thanks,

Acked-by: John Garry <john.garry@huawei.com>

