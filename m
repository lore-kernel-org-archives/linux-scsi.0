Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86481C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 08:47:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiCQIso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Mar 2022 04:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbiCQIsn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Mar 2022 04:48:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975311CABD6;
        Thu, 17 Mar 2022 01:47:27 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KK11k5DHqz67Y4H;
        Thu, 17 Mar 2022 16:45:30 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 17 Mar 2022 09:47:25 +0100
Received: from [10.47.84.96] (10.47.84.96) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 17 Mar
 2022 08:47:25 +0000
Message-ID: <8ea15300-9301-a54e-8a65-78aa46745d08@huawei.com>
Date:   Thu, 17 Mar 2022 08:47:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] scsi: hisi_sas: remove stray fallthrough annotation
To:     Dan Carpenter <dan.carpenter@oracle.com>
CC:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20220317075214.GC25237@kili>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220317075214.GC25237@kili>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.96]
X-ClientProxiedBy: lhreml735-chm.china.huawei.com (10.201.108.86) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/03/2022 07:52, Dan Carpenter wrote:
> This case statement doesn't fall through any more so remove the
> fallthrough annotation.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks

Acked-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/scsi/hisi_sas/hisi_sas_main.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
> index 461ef8a76c4c..4bda2f6cb352 100644
> --- a/drivers/scsi/hisi_sas/hisi_sas_main.c
> +++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
> @@ -442,7 +442,6 @@ void hisi_sas_task_deliver(struct hisi_hba *hisi_hba,
>   	case SAS_PROTOCOL_INTERNAL_ABORT:
>   		hisi_sas_task_prep_abort(hisi_hba, slot);
>   		break;
> -	fallthrough;
>   	default:
>   		return;
>   	}

