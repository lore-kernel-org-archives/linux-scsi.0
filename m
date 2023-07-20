Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA285C001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 01:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjGTB4I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGTB4H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 21:56:07 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C13F41FE9;
        Wed, 19 Jul 2023 18:56:05 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4R5whH0fTxzLnrb;
        Thu, 20 Jul 2023 09:53:35 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 09:56:02 +0800
Subject: Re: [PATCH v2 7/8] ata: sata_sx4: drop already completed TODO
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
CC:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-8-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <22e007c7-cde1-851a-55a5-f52694efce3f@huawei.com>
Date:   Thu, 20 Jul 2023 09:56:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230720004257.307031-8-nks@flawful.org>
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

On 2023/7/20 8:42, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> The TODO claims that the pdc_20621_ops should set the .inherits
> function pointer to &ata_base_port_ops after it has been converted
> to use the new EH.
> 
> However, the driver was converted to use the new EH a long time ago,
> in commit 67651ee5710c ("[libata] sata_sx4: convert to new exception
> handling methods"), which also did set .inherits function pointer to
> &ata_sff_port_ops (and ata_sff_port_ops itself has .inherits set to
> &ata_base_port_ops).
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/sata_sx4.c | 1 -
>   1 file changed, 1 deletion(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Thanks,
Jason
