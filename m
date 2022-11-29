Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3121C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Nov 2022 02:46:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235247AbiK2Cp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Nov 2022 21:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiK2Cp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2022 21:45:58 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7271E47313;
        Mon, 28 Nov 2022 18:45:57 -0800 (PST)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NLmnZ1wNfzqSfN;
        Tue, 29 Nov 2022 10:41:54 +0800 (CST)
Received: from dggpemm500012.china.huawei.com (7.185.36.89) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 10:45:55 +0800
Received: from [10.67.101.126] (10.67.101.126) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 29 Nov 2022 10:45:55 +0800
Message-ID: <66c9f444-ef8f-c56a-0b95-ed39715e4a75@huawei.com>
Date:   Tue, 29 Nov 2022 10:45:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] scsi: sd: Update dix config everytime sd_revalidate_disk
 is called
Content-Language: en-CA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <prime.zeng@hisilicon.com>, <kangfenglong@huawei.com>,
        <john.garry@huawei.com>
References: <20221019081825.20794-1-yangxingui@huawei.com>
 <yq1h6zzz740.fsf@ca-mkp.ca.oracle.com>
From:   yangxingui <yangxingui@huawei.com>
In-Reply-To: <yq1h6zzz740.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.126]
X-ClientProxiedBy: dggpemm500019.china.huawei.com (7.185.36.180) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2022/10/20 8:18, Martin K. Petersen wrote:
> 
> Xingui,
> 
>> When the host protection capabilities are 0x77 and a DIF disk is
>> connected, the DIX and DIF of the disk are default enabled. Then if
>> that DIF disk is reformatted as a non-DIF format, per the currently
>> flow, the DIX is kept enabled which is not correct
> 
> DIX is orthogonal to DIF and a host property. DIX should not be disabled
> just because the disk is no longer formatted with protection
> information.
> 
> That said, your patch is probably fine. I'll take a closer look
> tomorrow.
> 

Friendly ping... Do you have other suggestions?
Thanks,
Xingui
