Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECBEAC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED4561157
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 06:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240079AbhING3e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 02:29:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9865 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239936AbhING3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 02:29:34 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7tb81HJVz8yFx;
        Tue, 14 Sep 2021 14:23:48 +0800 (CST)
Received: from [10.174.178.185] (10.174.178.185) by
 dggeme754-chm.china.huawei.com (10.3.19.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Tue, 14 Sep 2021 14:28:13 +0800
Subject: Re: [PATCH -next 0/2] Fix out-of-bound in resp_readcap16 and
 resp_report_tgtpgs
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20210818021428.3720233-1-yebin10@huawei.com>
From:   yebin <yebin10@huawei.com>
Message-ID: <614040FD.3000209@huawei.com>
Date:   Tue, 14 Sep 2021 14:28:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <20210818021428.3720233-1-yebin10@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.185]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggeme754-chm.china.huawei.com (10.3.19.100)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ping...

On 2021/8/18 10:14, Ye Bin wrote:
> Ye Bin (2):
>    scsi:scsi_debug: Fix out-of-bound in resp_readcap16
>    scsi:scsi_debug: Fix potential OOB in resp_report_tgtpgs
>
>   drivers/scsi/scsi_debug.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)
>

