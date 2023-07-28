Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 981B9C04A6A
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jul 2023 02:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjG1CHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 22:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjG1CHK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 22:07:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDA2E2D6A;
        Thu, 27 Jul 2023 19:07:09 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RBrXJ5bk7zNmXH;
        Fri, 28 Jul 2023 10:03:44 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 28 Jul 2023 10:07:07 +0800
Subject: Re: [PATCH v3 9/9] ata: remove deprecated EH callbacks
To:     Niklas Cassel <nks@flawful.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sergey Shtylyov <s.shtylyov@omp.ru>
CC:     Hannes Reinecke <hare@suse.com>,
        John Garry <john.g.garry@oracle.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        <linux-doc@vger.kernel.org>
References: <20230721163229.399676-1-nks@flawful.org>
 <20230721163229.399676-10-nks@flawful.org>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <d2d7f0bb-163c-ecbe-70f1-a1d520e445a3@huawei.com>
Date:   Fri, 28 Jul 2023 10:07:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230721163229.399676-10-nks@flawful.org>
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
> Now when all libata drivers have migrated to use the error_handler
> callback, remove the deprecated phy_reset and eng_timeout callbacks.
> 
> Also remove references to non-existent functions sata_phy_reset and
> ata_qc_timeout from Documentation/driver-api/libata.rst.
> 
> Signed-off-by: Niklas Cassel<niklas.cassel@wdc.com>
> ---
>   Documentation/driver-api/libata.rst | 22 ++++++----------------
>   drivers/ata/pata_sl82c105.c         |  3 +--
>   include/linux/libata.h              |  6 ------
>   3 files changed, 7 insertions(+), 24 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
