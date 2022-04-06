Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA1BC433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 11:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiDFLzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 07:55:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiDFLyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 07:54:54 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2FC2DBFE7;
        Wed,  6 Apr 2022 00:16:42 -0700 (PDT)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KYG2L3gttz67tDy;
        Wed,  6 Apr 2022 15:13:30 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Apr 2022 09:16:27 +0200
Received: from [10.47.80.129] (10.47.80.129) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 6 Apr
 2022 08:16:26 +0100
Message-ID: <febb03e4-ea1d-c7e1-58a6-fa564c902af0@huawei.com>
Date:   Wed, 6 Apr 2022 08:16:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 2/2] libata: Inline ata_qc_new_init() in
 ata_scsi_qc_new()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>
CC:     <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-scsi@vger.kernel.org>
References: <1649083990-207133-1-git-send-email-john.garry@huawei.com>
 <1649083990-207133-3-git-send-email-john.garry@huawei.com>
 <20220405055252.GA23698@lst.de>
 <f7bbb09f-562f-fce2-cd16-a1c67fc334b5@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <f7bbb09f-562f-fce2-cd16-a1c67fc334b5@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.129]
X-ClientProxiedBy: lhreml728-chm.china.huawei.com (10.201.108.79) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/04/2022 02:48, Damien Le Moal wrote:
> On 4/5/22 14:52, Christoph Hellwig wrote:
>> On Mon, Apr 04, 2022 at 10:53:10PM +0800, John Garry wrote:
>>> From: Christoph Hellwig <hch@lst.de>
>>>
>>> It is a bit pointless to have ata_qc_new_init() in libata-core.c 
>>> since it
>>> pokes scsi internals, so inline it in ata_scsi_qc_new() (in 
>>> libata-scsi.c).
>>>
>>> <Christoph, please provide signed-off-by>
>>> [jpg, Take Christoph's change from list and form into a patch]
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>
>> Although I still think merging the two patches into one to avoid all
>> the churn would be much better.
> 
> I agree. Let's merge these 2 patches.

I'd say that they are distinct changes.

Anyway, if that is the preference then who shall be the author? 
Considering I did most effort I will be and add Christoph as 
co-developed-by - please let me know if not ok.

thanks,
John
