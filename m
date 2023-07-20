Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09E7AC001DE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Jul 2023 01:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjGTBxE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 21:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjGTBxD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 21:53:03 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1509FC1;
        Wed, 19 Jul 2023 18:53:03 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4R5wc16T4bztRZ2;
        Thu, 20 Jul 2023 09:49:53 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 20 Jul 2023 09:53:00 +0800
Subject: Re: [PATCH v2 4/8] ata: remove ata_sas_sync_probe()
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>
CC:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20230720004257.307031-1-nks@flawful.org>
 <20230720004257.307031-5-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <5ecdd708-8d7c-981e-0d84-d9a2356765ab@huawei.com>
Date:   Thu, 20 Jul 2023 09:53:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230720004257.307031-5-nks@flawful.org>
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

On 2023/7/20 8:42, Niklas Cassel wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Unused.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/ata/libata-sata.c | 7 -------
>   include/linux/libata.h    | 1 -
>   2 files changed, 8 deletions(-)
> 
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index b5de0f40ea25..23252ebe312d 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -1157,13 +1157,6 @@ void ata_sas_async_probe(struct ata_port *ap)
>   }
>   EXPORT_SYMBOL_GPL(ata_sas_async_probe);
>   
> -int ata_sas_sync_probe(struct ata_port *ap)
> -{
> -	return ata_port_probe(ap);
> -}
> -EXPORT_SYMBOL_GPL(ata_sas_sync_probe);
> -
> -
>   /**
>    *	ata_sas_port_init - Initialize a SATA device
>    *	@ap: SATA port to initialize
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 53cfb1a4b97a..86490718cd0d 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1241,7 +1241,6 @@ extern int ata_slave_link_init(struct ata_port *ap);
>   extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
>   					   struct ata_port_info *, struct Scsi_Host *);
>   extern void ata_sas_async_probe(struct ata_port *ap);
> -extern int ata_sas_sync_probe(struct ata_port *ap);
>   extern int ata_sas_port_init(struct ata_port *);
>   extern int ata_sas_tport_add(struct device *parent, struct ata_port *ap);
>   extern void ata_sas_tport_delete(struct ata_port *ap);
> 

Reviewed-by: Jason Yan <yanaijie@huawei.com>

Thanks,
Jason
