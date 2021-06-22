Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68A9BC2B9F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:24:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45A686044F
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Jun 2021 09:24:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhFVJ1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Jun 2021 05:27:05 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3299 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhFVJ1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jun 2021 05:27:04 -0400
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4G8LQG6qcyz6DBWj;
        Tue, 22 Jun 2021 17:17:26 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 22 Jun 2021 11:24:47 +0200
Received: from [10.47.93.67] (10.47.93.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 22 Jun
 2021 10:24:46 +0100
Subject: Re: [PATCH v3] scsi: libsas: add lun number check in .slave_alloc
 callback
To:     Jason Yan <yanaijie@huawei.com>, Yufen Yu <yuyufen@huawei.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Wu Bo <wubo40@huawei.com>
References: <20210622034037.1467088-1-yuyufen@huawei.com>
 <af233a61-76a5-d4fe-e190-2f4d020df31a@huawei.com>
 <d9757dc3-851d-e7bf-e59a-58e7f761d4bd@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <723bc6cd-157c-5b8c-842e-8bbd836042dd@huawei.com>
Date:   Tue, 22 Jun 2021 10:18:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <d9757dc3-851d-e7bf-e59a-58e7f761d4bd@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.93.67]
X-ClientProxiedBy: lhreml747-chm.china.huawei.com (10.201.108.197) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/06/2021 10:15, Jason Yan wrote:
>>
>> I thought that we would mention why we don't change aic7xxx driver.
> 
> We are talking about libsas here. aic7xxx is not even a libsas driver,
> so I don't think we need to mention it.

Ah, right. I don't know why it was mentioned when we were talking about 
the v2 of this patch.

Thanks,
John
