Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CE9C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 06:15:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 148D561107
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 06:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbhG0GPx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Jul 2021 02:15:53 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:7876 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235296AbhG0GPq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jul 2021 02:15:46 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GYmf01jtLz80lF;
        Tue, 27 Jul 2021 14:11:52 +0800 (CST)
Received: from dggema773-chm.china.huawei.com (10.1.198.217) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 27 Jul 2021 14:15:36 +0800
Received: from [10.174.179.2] (10.174.179.2) by dggema773-chm.china.huawei.com
 (10.1.198.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 27
 Jul 2021 14:15:35 +0800
Subject: Re: [PATCH v2] scsi: Fix the issue that the disk capacity set to zero
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <john.garry@huawei.com>,
        <bvanassche@acm.org>, <yanaijie@huawei.com>,
        <linfeilong@huawei.com>, <wubo40@huawei.com>
References: <20210727034455.1494960-1-lijinlin3@huawei.com>
 <yq135s0qw1w.fsf@ca-mkp.ca.oracle.com>
From:   lijinlin <lijinlin3@huawei.com>
Message-ID: <6d8b45b2-c201-091b-2eed-9a3de317e74d@huawei.com>
Date:   Tue, 27 Jul 2021 14:15:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <yq135s0qw1w.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.2]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggema773-chm.china.huawei.com (10.1.198.217)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Patch v2 only change 'scsi_sysfs:' to 'scsi:' in subject, thanks.

On 2021/7/27 11:25, Martin K. Petersen wrote:> 
> lijinlin,
> 
> What changed in v2? Please make sure to include a change log after the
> "---" separator when you resubmit a patch.
> 
> Thank you!
> 
