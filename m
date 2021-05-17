Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9B6BC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 09:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C64BC61206
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 09:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbhEQJvy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 05:51:54 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2951 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbhEQJvy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 05:51:54 -0400
Received: from dggems704-chm.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FkDny4LMszCt3N;
        Mon, 17 May 2021 17:47:50 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems704-chm.china.huawei.com (10.3.19.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 17 May 2021 17:50:35 +0800
Received: from [10.47.83.99] (10.47.83.99) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 17 May
 2021 10:50:32 +0100
Subject: Re: [PATCH 20/50] hisi_sas: Use blk_req() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210514213356.5264-1-bvanassche@acm.org>
 <20210514213356.5264-72-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6fca3f4e-ae54-36fd-c689-0d05fde9a3ba@huawei.com>
Date:   Mon, 17 May 2021 10:49:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210514213356.5264-72-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.99]
X-ClientProxiedBy: lhreml716-chm.china.huawei.com (10.201.108.67) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/05/2021 22:33, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using blk_req() instead. This
> patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Acked-by: John Garry <john.garry@huawei.com>
