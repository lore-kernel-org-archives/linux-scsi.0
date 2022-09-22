Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFD18C6FA90
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 08:14:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiIVIO0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 04:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbiIVIOW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 04:14:22 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4533CD1DA
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 01:14:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=gumi@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VQRit6V_1663834456;
Received: from 30.178.81.208(mailfrom:gumi@linux.alibaba.com fp:SMTPD_---0VQRit6V_1663834456)
          by smtp.aliyun-inc.com;
          Thu, 22 Sep 2022 16:14:18 +0800
Message-ID: <06d82a11-0bba-c872-587e-07dc7ca46cf2@linux.alibaba.com>
Date:   Thu, 22 Sep 2022 16:14:15 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: [PATCH] scsi: mpt3sas: add some indentation
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <1663597267-79308-1-git-send-email-gumi@linux.alibaba.com>
From:   Gu Mi <gumi@linux.alibaba.com>
In-Reply-To: <1663597267-79308-1-git-send-email-gumi@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> The line is indented too short, so it's a bit confusing.
>
> Signed-off-by: Gu Mi <gumi@linux.alibaba.com>
> ---
>   drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index bd6a5f1..025c6c7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -10907,7 +10907,7 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
>   			return 1;
>   		break;
>   	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> -	_scsih_check_pcie_topo_remove_events(ioc,
> +		_scsih_check_pcie_topo_remove_events(ioc,
>   		    (Mpi26EventDataPCIeTopologyChangeList_t *)
>   		    mpi_reply->EventData);
>   		if (ioc->shost_recovery)
