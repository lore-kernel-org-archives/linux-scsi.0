Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7816EC432BE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DEB5611B0
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Aug 2021 08:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243621AbhHFIQF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Aug 2021 04:16:05 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3600 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243752AbhHFIPl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Aug 2021 04:15:41 -0400
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GgyvX099Lz6GFKK;
        Fri,  6 Aug 2021 16:15:04 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 6 Aug 2021 10:15:24 +0200
Received: from [10.47.24.8] (10.47.24.8) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 6 Aug 2021
 09:15:23 +0100
Subject: Re: [PATCH v4 26/52] libsas: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>,
        "Liu Shixin" <liushixin2@huawei.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jolly Shah <jollys@google.com>, Yufen Yu <yuyufen@huawei.com>
References: <20210805191828.3559897-1-bvanassche@acm.org>
 <20210805191828.3559897-27-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4b92592d-5c0d-d54a-6400-c3ad9fb6d906@huawei.com>
Date:   Fri, 6 Aug 2021 09:14:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210805191828.3559897-27-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.24.8]
X-ClientProxiedBy: lhreml706-chm.china.huawei.com (10.201.108.55) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/08/2021 20:18, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche<bvanassche@acm.org>

Reviewed-by: John Garry <john.garry@huawei.com>
