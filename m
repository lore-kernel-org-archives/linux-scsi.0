Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D96BC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 15:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbiEaPML (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 11:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344487AbiEaPML (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 11:12:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 716235DD36
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 08:12:09 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LCFzK5YdKz67bMY;
        Tue, 31 May 2022 23:08:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 17:12:06 +0200
Received: from [10.47.88.115] (10.47.88.115) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 31 May
 2022 16:12:06 +0100
Message-ID: <5d28e848-0b9d-2aaa-e00e-7888342d25a7@huawei.com>
Date:   Tue, 31 May 2022 16:12:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 01/10] scsi/mvsas: Kill CONFIG_SCSI_MVSAS_TASKLET
To:     Davidlohr Bueso <dave@stgolabs.net>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <ejb@linux.ibm.com>, <bigeasy@linutronix.de>, <tglx@linutronix.de>
References: <20220530231512.9729-1-dave@stgolabs.net>
 <20220530231512.9729-2-dave@stgolabs.net>
 <17747966-ea44-ebe5-3d79-df7c33b6a16e@huawei.com>
 <20220531145231.opypdzrlrg23ihil@offworld>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220531145231.opypdzrlrg23ihil@offworld>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.115]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 31/05/2022 15:52, Davidlohr Bueso wrote:
> On Tue, 31 May 2022, John Garry wrote:
>> Question: Can there be any good reason to do this?
> 
> Removing tasklets altogether, albeit perhaps a pipe dream.

Sorry, maybe I was not clear, but I was just asking if there was a good 
reason to disable interrupts at source while handling the interrupt, and 
not the change to stop using a tasklet.

Thanks,
John
