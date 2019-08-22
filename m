Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA081C3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:37:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85A372082F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 14:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731611AbfHVOhL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 10:37:11 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:38770 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729731AbfHVOhK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 10:37:10 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D696CA1D402D4DDE0E6B;
        Thu, 22 Aug 2019 22:36:25 +0800 (CST)
Received: from [127.0.0.1] (10.202.227.238) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 22:36:15 +0800
Subject: Re: [PATCH] scsi: hisi_sas: remove set but not used variable
 'irq_value'
To:     zhengbin <zhengbin13@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
References: <1566483647-121127-1-git-send-email-zhengbin13@huawei.com>
CC:     <yi.zhang@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <b2269743-fd2a-fc57-dd8d-e4e645d6eb7b@huawei.com>
Date:   Thu, 22 Aug 2019 15:36:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.3.0
MIME-Version: 1.0
In-Reply-To: <1566483647-121127-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.238]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/08/2019 15:20, zhengbin wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c: In function cq_interrupt_v1_hw:
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1542:6: warning: variable irq_value set but not used [-Wunused-but-set-variable]
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---

Acked-by: John Garry <john.garry@huawei.com>

