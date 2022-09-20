Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B424C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 13:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbiITNIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 09:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiITNIC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 09:08:02 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868796050A;
        Tue, 20 Sep 2022 06:07:56 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MX1y76skfz687YQ;
        Tue, 20 Sep 2022 21:06:07 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 15:07:49 +0200
Received: from [10.126.173.140] (10.126.173.140) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 20 Sep 2022 14:07:48 +0100
Message-ID: <dc892956-56bf-19aa-f206-b3bbcc781fea@huawei.com>
Date:   Tue, 20 Sep 2022 14:07:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: Re: Do we still need the scsi IPR driver ?
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Brian King <brking@linux.vnet.ibm.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
 <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
In-Reply-To: <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.173.140]
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 21/06/2022 23:12, Damien Le Moal wrote:
>>> We still need it around for now. IBM still sells these adapters
>>> and they can still be ordered even on our latest Power 10 systems.
>> At one point I did look into modifying ipr to use an ->error_handler.
>> I recall I ran into some issues that resulted in this getting put
>> on the shelf, but its been a while. I'll go dig that code up and
>> see what it looks like.
> Thanks. It would be really great if you can convert to using
> error_handler. This is really the last ata/libsas driver that does not use
> this.
> 

Hi Brian,

I am wondering if there is any update here?

As you may have seen in [0], I think that we need to make progress on 
this topic first to keep the solution there a bit simpler.

[0] 
https://lore.kernel.org/linux-scsi/1663669630-21333-1-git-send-email-john.garry@huawei.com/T/#mf890cb4f1627112652831524dca62cbde4a0a637

Thanks,
John
