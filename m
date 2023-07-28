Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E794C04A6A
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 02:05:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbjG1CFw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 22:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbjG1CFv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 22:05:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C1B32D73;
        Thu, 27 Jul 2023 19:05:50 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RBrXq73nrzVjly;
        Fri, 28 Jul 2023 10:04:11 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 10:05:47 +0800
Subject: Re: [PATCH v3 2/9] ata,scsi: remove ata_sas_port_{start,stop}
 callbacks
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        John Garry <john.g.garry@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Hannes Reinecke <hare@suse.com>, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-3-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <ed32011d-4bba-2679-5efd-b8bc164d4ecf@huawei.com>
Date:   Fri, 28 Jul 2023 10:05:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230721163229.399676-3-nks@flawful.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/7/22 0:32, Niklas Cassel wrote:
> Also, remove the call to ap->ops->port_start() in ata_sas_port_init(),
> as this would otherwise cause a NULL pointer dereference, now when the
> callback is gone.
> 
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> [niklas: remove the call to ap->ops->port_start() in ata_sas_port_init()]
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-sata.c     | 38 -----------------------------------
>   drivers/scsi/libsas/sas_ata.c |  2 --
>   include/linux/libata.h        |  2 --
>   3 files changed, 42 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
