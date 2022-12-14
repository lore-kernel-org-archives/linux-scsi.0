Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81952C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 12:48:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238147AbiLNMs4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 07:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237918AbiLNMsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 07:48:35 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A121C91F
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 04:47:15 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NXFQ73XYJzqT8M;
        Wed, 14 Dec 2022 20:42:55 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Dec 2022 20:47:12 +0800
Subject: Re: [PATCH v3 4/5] scsi: libsas: factor out sas_ata_add_dev()
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>
References: <20221214070608.4128546-1-yanaijie@huawei.com>
 <20221214070608.4128546-5-yanaijie@huawei.com>
 <f808191f-6723-257b-6cd6-3e2db2fa4b27@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <913a6c69-6aa4-2d18-ecee-2fa8b97c888e@huawei.com>
Date:   Wed, 14 Dec 2022 20:47:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <f808191f-6723-257b-6cd6-3e2db2fa4b27@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/14 18:05, John Garry wrote:
> On 14/12/2022 07:06, Jason Yan wrote:
>> Factor out sas_ata_add_dev() and put it in sas_ata.c since it is a sata
>> related interface. Also follow the standard coding style to define an
>> inline empty function when CONFIG_SCSI_SAS_ATA is not enabled.
>>
>> Cc: John Garry<john.g.garry@oracle.com>
>> Signed-off-by: Jason Yan<yanaijie@huawei.com>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 

Thanks John.

> Note: you made the changes as I suggested, so I think that you could 
> have picked up my RB tag from v2 series, thanks.

Yeah I used to do that before. But last time Damien educated me that I
must drop all the RB tags after the patch is changed so I didn't take
it.

May I should remember reviewer's personal preference ^-^

Thanks
Jason

> .
