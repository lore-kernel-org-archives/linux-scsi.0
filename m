Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39453C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 02:54:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236608AbiLNCyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Dec 2022 21:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235717AbiLNCyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2022 21:54:54 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB15232F
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 18:54:53 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NX0LR1dPDzRpym;
        Wed, 14 Dec 2022 10:53:51 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Dec 2022 10:54:51 +0800
Subject: Re: [PATCH v2 0/5] scsi: libsas: Some coding style fixes and cleanups
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221213150942.988371-1-yanaijie@huawei.com>
 <ad43f2a5-286f-b079-3b6a-f773fd7c4c30@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <cce7077b-c62e-9208-88f5-4ed86ddf9a27@huawei.com>
Date:   Wed, 14 Dec 2022 10:54:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ad43f2a5-286f-b079-3b6a-f773fd7c4c30@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/14 0:12, John Garry wrote:
> On 13/12/2022 15:09, Jason Yan wrote:
>> A few coding style fixes and cleanups. There should be no functional
>> changes in this series besides the debug log prints.
>>
>> v1->v2:
>>    1. Drop patch #2 in v1.
>>    2. Other misc changes suggested by John.
> 
> Note: it would be better to concisely mention the actual changes, so 
> that we know what to look for in the new version. Just writing something 
> like "incorporate changes suggested by <insert name>" is unfortunately 
> not much use.
> 

Yeah, my bad.

Thank you for your patience, John.
