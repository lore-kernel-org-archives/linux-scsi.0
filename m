Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00CE9C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAED161076
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbhIFB3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:29:02 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15291 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240936AbhIFB1F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:27:05 -0400
Received: from dggeml756-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4H2rLh2dmBz8sqg;
        Mon,  6 Sep 2021 09:25:32 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 dggeml756-chm.china.huawei.com (10.1.199.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 6 Sep 2021 09:25:59 +0800
Subject: Re: [PATCH] scsi: libsas: co-locate exports with symbols
To:     John Garry <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1630664852-225115-1-git-send-email-john.garry@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <f767b99a-e4cb-642f-a319-5cea2b4a2a88@huawei.com>
Date:   Mon, 6 Sep 2021 09:25:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <1630664852-225115-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggeml756-chm.china.huawei.com (10.1.199.158)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


ÔÚ 2021/9/3 18:27, John Garry Ð´µÀ:
> It is standard practice to co-locate export declarations with the symbol
> which is being exported. Or at least in the same file - see
> sas_phy_reset().
> 
> Modify libsas to follow this practice consistently.
> 
> Signed-off-by: John Garry<john.garry@huawei.com>

Reviewed-by: Jason Yan <yanaijie@huawei.com>
