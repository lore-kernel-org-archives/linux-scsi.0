Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7823C25B08
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Aug 2022 08:20:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235234AbiHQIUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Aug 2022 04:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233858AbiHQIUP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2022 04:20:15 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0ED58DD9
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2022 01:20:12 -0700 (PDT)
Received: from fraeml742-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4M716F34j6z67MQZ;
        Wed, 17 Aug 2022 16:15:17 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml742-chm.china.huawei.com (10.206.15.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 10:20:10 +0200
Received: from [10.48.158.152] (10.48.158.152) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 17 Aug 2022 09:20:09 +0100
Message-ID: <e1c72e6f-3407-e8df-11ab-b944b11fa00c@huawei.com>
Date:   Wed, 17 Aug 2022 09:20:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: sd: Revert "Rework asynchronous resume support"
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>, <gzhqyz@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220816172638.538734-1-bvanassche@acm.org>
 <8a83665a-1951-a326-f930-8fcbb0c4dd9a@huawei.com>
 <f6b710f8-2c66-c6f8-8441-a0e9edb2ae8e@acm.org>
In-Reply-To: <f6b710f8-2c66-c6f8-8441-a0e9edb2ae8e@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.158.152]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 16/08/2022 19:06, Bart Van Assche wrote:
> On 8/16/22 11:00, John Garry wrote:
>> JFYI, Just now I see that 88f1669019bd also causes me issues for my 
>> SATA disk: [ ... ]
> Hi John,
> 
> Does reverting commit 88f1669019bd help on your setup?

Yes,

Tested-by: John Garry <john.garry@huawei.com>
