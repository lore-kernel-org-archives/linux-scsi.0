Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3541AC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 10:57:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbiJQK5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 06:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiJQK5I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 06:57:08 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ABA45C95A;
        Mon, 17 Oct 2022 03:57:06 -0700 (PDT)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4MrYnd2ycPz67L3d;
        Mon, 17 Oct 2022 18:56:05 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 12:57:03 +0200
Received: from [10.202.227.197] (10.202.227.197) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 17 Oct 2022 11:57:03 +0100
Message-ID: <a798fce4-f1bd-39b0-efbe-c86434b80dd7@huawei.com>
Date:   Mon, 17 Oct 2022 11:57:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v6 1/8] scsi: libsas: Add sas_ata_device_link_abort()
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>,
        "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "yangxingui@huawei.com" <yangxingui@huawei.com>
References: <1665998435-199946-1-git-send-email-john.garry@huawei.com>
 <1665998435-199946-2-git-send-email-john.garry@huawei.com>
 <Y00z68i9V/p/0tuI@x1-carbon>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <Y00z68i9V/p/0tuI@x1-carbon>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.197]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/10/2022 11:52, Niklas Cassel wrote:
>> The SATA device FIS fields are set to indicate a device error from
>> ata_eh_analyze_tf().
>>
>> Suggested-by: Damien Le Moal<damien.lemoal@opensource.wdc.com>
>> Suggested-by: Tested-by: Niklas Cassel<niklas.cassel@wdc.com>
> Nit: is this perhaps a typo?

Yeah, a copy and paste error.

> (Since there is another Tested-by tag later in the list.)
> 
> Checkpatch doesn't complain, so I guess no biggie,
> but might be worth fixing if you decide to roll a v7.

Sure

Thanks,
John
