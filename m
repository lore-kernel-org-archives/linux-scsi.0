Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB20C001B0
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 09:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbjHOJcD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 05:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236350AbjHOJbW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 05:31:22 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492591BCE;
        Tue, 15 Aug 2023 02:30:21 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RQ5Xs6wvrzVk3v;
        Tue, 15 Aug 2023 17:28:13 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 15 Aug 2023 17:30:17 +0800
Subject: Re: [PATCH 02/10] scsi: libsas: Delete enum sas_class
To:     John Garry <john.g.garry@oracle.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <chenxiang66@hisilicon.com>,
        <artur.paszkiewicz@intel.com>, <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dlemoal@kernel.org>
References: <20230814141022.36875-1-john.g.garry@oracle.com>
 <20230814141022.36875-3-john.g.garry@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <9ba84361-8469-92ce-93bf-94dccb24cdd0@huawei.com>
Date:   Tue, 15 Aug 2023 17:30:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230814141022.36875-3-john.g.garry@oracle.com>
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

On 2023/8/14 22:10, John Garry wrote:
> enum sas_class prob would have been useful if function sas_show_class() was
> ever implemented, which it wasn't.
> 
> enum sas_class is used as asd_sas_port.class and asd_sas_phy.class, which
> are only ever set, so delete these members and the enum.
> 
> Signed-off-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/aic94xx/aic94xx_hwi.c    | 1 -
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
>   drivers/scsi/isci/phy.c               | 1 -
>   drivers/scsi/libsas/sas_internal.h    | 1 -
>   drivers/scsi/libsas/sas_port.c        | 2 --
>   drivers/scsi/mvsas/mv_init.c          | 1 -
>   drivers/scsi/pm8001/pm8001_init.c     | 1 -
>   include/scsi/libsas.h                 | 7 -------
>   8 files changed, 15 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
