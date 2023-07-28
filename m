Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE6F2C04A6A
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 02:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjG1CGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 22:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231578AbjG1CGj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 22:06:39 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6ED2D6A;
        Thu, 27 Jul 2023 19:06:39 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RBrZY2tmdzrRqV;
        Fri, 28 Jul 2023 10:05:41 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 10:06:36 +0800
Subject: Re: [PATCH v3 8/9] ata: remove ata_bus_probe()
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
CC:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        <linux-doc@vger.kernel.org>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-9-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <713a8574-5d1f-d988-d409-333cce7e1c3b@huawei.com>
Date:   Fri, 28 Jul 2023 10:06:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230721163229.399676-9-nks@flawful.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/7/22 0:32, Niklas Cassel wrote:
> From: Niklas Cassel<niklas.cassel@wdc.com>
> 
> Remove ata_bus_probe() as it is unused.
> 
> Also, remove references to ata_bus_probe and port_disable in
> Documentation/driver-api/libata.rst, as neither exist anymore.
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> ---
>   Documentation/driver-api/libata.rst |  16 ----
>   drivers/ata/libata-core.c           | 138 ----------------------------
>   drivers/ata/libata.h                |   1 -
>   include/linux/libata.h              |   1 -
>   4 files changed, 156 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
