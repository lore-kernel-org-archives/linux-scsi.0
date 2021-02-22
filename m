Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70267C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:33:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2452664E00
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:33:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBVId2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:33:28 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2591 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbhBVId1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 03:33:27 -0500
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DkZxm2bjyz67bmb;
        Mon, 22 Feb 2021 16:25:32 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 22 Feb 2021 09:32:43 +0100
Received: from [10.210.165.112] (10.210.165.112) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Feb 2021 08:32:43 +0000
Subject: Re: [PATCH] scsi: iscsi: Switch to using the new API kobj_to_dev()
To:     Yang Li <yang.lee@linux.alibaba.com>, <martin.petersen@oracle.com>
CC:     <jejb@linux.ibm.com>, <lduncan@suse.com>, <cleech@redhat.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1613978804-4846-1-git-send-email-yang.lee@linux.alibaba.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <4fa2baa0-8727-9e72-eb42-db773401b8a1@huawei.com>
Date:   Mon, 22 Feb 2021 08:30:57 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1613978804-4846-1-git-send-email-yang.lee@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.165.112]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2021 07:26, Yang Li wrote:
> fixed the following coccicheck:
> ./drivers/scsi/scsi_transport_iscsi.c:436:60-61: WARNING opportunity for
> kobj_to_dev()
> ./drivers/scsi/scsi_transport_iscsi.c:1128:60-61: WARNING opportunity
> for kobj_to_dev()
> ./drivers/scsi/scsi_transport_iscsi.c:4043:61-62: WARNING opportunity
> for kobj_to_dev()
> ./drivers/scsi/scsi_transport_iscsi.c:4312:61-62: WARNING opportunity
> for kobj_to_dev()
> ./drivers/scsi/scsi_transport_iscsi.c:4456:61-62: WARNING opportunity
> for kobj_to_dev()

that API is not new, so please in future stop writing that. And 'new' is 
a time-dependent term, and not appropriate to use anyway.

Thanks,
John

> 
> Reported-by: Abaci Robot<abaci@linux.alibaba.com>
> Signed-off-by: Yang Li<yang.lee@linux.alibaba.com>

