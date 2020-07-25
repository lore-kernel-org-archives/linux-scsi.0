Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 816DFC433E3
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 09:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B287206D8
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 09:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgGYJAG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jul 2020 05:00:06 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:8280 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726583AbgGYJAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 25 Jul 2020 05:00:06 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5CB92F8EE246C408FD4E;
        Sat, 25 Jul 2020 17:00:03 +0800 (CST)
Received: from [127.0.0.1] (10.57.22.126) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Sat, 25 Jul 2020
 16:59:53 +0800
Subject: Re: [PATCH v2 0/2] scsi: libsas: An improvement on error handle and
 tidy-up
To:     <martin.petersen@oracle.com>, <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <john.garry@huawei.com>, <yanaijie@huawei.com>,
        <chenxiang66@hisilicon.com>, <linuxarm@huawei.com>
References: <1595665131-24543-1-git-send-email-luojiaxing@huawei.com>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <90974ce1-abd4-7b6d-c4cf-08e4a922c6fd@huawei.com>
Date:   Sat, 25 Jul 2020 16:59:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <1595665131-24543-1-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.57.22.126]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sorry，I missed Martin's e-mail "Re: [PATCH v1 0/2] scsi: libsas: An 
improvement on error handle and tidy-up" here. Please ignore this set of 
patches.

On 2020/7/25 16:18, Luo Jiaxing wrote:
> This patch introduces an improvement to reduce error handle time and a
> tidy-up, including:
> - postreset() is deleted from sas_sata_ops.
> - Do not perform hard reset and delayed retry on a removed SATA disk. This
> can effectively reduce the error handle duration of hot unplug a SATA disk
> with traffic(reduce about 30s depending on the delay setting of libata).
>
> Both John garry and Jason Yan participated in the review of the solution
> and provided good suggestions during the development.
>
> Change since v1:
> - Removed an unnecessary tag from subject.
>
> Luo Jiaxing (2):
>    scsi: libsas: delete postreset at sas_sata_ops
>    scsi: libsas: check link status at ATA prereset() ops
>
>   drivers/scsi/libsas/sas_ata.c | 17 +++++++++++++++--
>   1 file changed, 15 insertions(+), 2 deletions(-)
>

