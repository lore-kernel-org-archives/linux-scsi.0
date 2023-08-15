Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4403C41513
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 09:38:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbjHOJh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 05:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236214AbjHOJhd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 05:37:33 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0791BD1;
        Tue, 15 Aug 2023 02:37:31 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4RQ5gQ0SQkztRfn;
        Tue, 15 Aug 2023 17:33:54 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Tue, 15 Aug 2023 17:37:29 +0800
Subject: Re: [PATCH 09/10] scsi: libsas: Delete sas_ata_task.stp_affil_pol
To:     John Garry <john.g.garry@oracle.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <chenxiang66@hisilicon.com>,
        <artur.paszkiewicz@intel.com>, <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <dlemoal@kernel.org>
References: <20230814141022.36875-1-john.g.garry@oracle.com>
 <20230814141022.36875-10-john.g.garry@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <2afe3f1f-42b1-f46b-28f2-1a0d031a5577@huawei.com>
Date:   Tue, 15 Aug 2023 17:37:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20230814141022.36875-10-john.g.garry@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/8/14 22:10, John Garry wrote:
> Since libsas was introduced in commit 2908d778ab3e ("[SCSI] aic94xx: new
> driver"), sas_ata_task.stp_affil_pol is never set, so delete it and the
> reference in asd_build_ata_ascb().
> 
> Signed-off-by: John Garry<john.g.garry@oracle.com>
> ---
>   drivers/scsi/aic94xx/aic94xx_task.c | 6 +-----
>   include/scsi/libsas.h               | 1 -
>   2 files changed, 1 insertion(+), 6 deletions(-)

Reviewed-by: Jason Yan <yanaijie@huawei.com>
