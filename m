Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7459DC001B2
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 13:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbiLNN3G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 08:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiLNN3F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 08:29:05 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7BB240BD
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 05:29:03 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NXGPz601BzlVpZ;
        Wed, 14 Dec 2022 21:27:51 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Dec 2022 21:28:50 +0800
Subject: Re: [PATCH v3 4/5] scsi: libsas: factor out sas_ata_add_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221214070608.4128546-1-yanaijie@huawei.com>
 <20221214070608.4128546-5-yanaijie@huawei.com>
 <f808191f-6723-257b-6cd6-3e2db2fa4b27@oracle.com>
 <913a6c69-6aa4-2d18-ecee-2fa8b97c888e@huawei.com>
 <113358cf-dde7-2494-744b-e5017db30948@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <e177044b-f10b-8a7b-9048-060c31b398ad@huawei.com>
Date:   Wed, 14 Dec 2022 21:28:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <113358cf-dde7-2494-744b-e5017db30948@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/14 21:16, John Garry wrote:
> On 14/12/2022 12:47, Jason Yan wrote:
>>> Note: you made the changes as I suggested, so I think that you could 
>>> have picked up my RB tag from v2 series, thanks.
>>
>> Yeah I used to do that before. But last time Damien educated me that I
>> must drop all the RB tags after the patch is changed so I didn't take
>> it.
> 
> I think that they should be dropped if significant changes are made 
> since the original tag was granted - that's for sure.
> 

Yes, definitely.

> However if I supply a RB tag but also suggest a smallish change along 
> with it and you implement that change in a new version, then it's ok to 
> pick up the tag.

Thanks for the explanation. I'm not sure if Damien agree with that.

> 
> At a brief glance, I could not see this policy mentioned in 
> submitting-patches.rst .
> 
> Thanks!
> .
