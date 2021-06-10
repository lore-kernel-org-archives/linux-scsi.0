Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F362C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F5D6613D2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:38:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFJDkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:40:15 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:9055 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhFJDkO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:40:14 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0qPB6gT3zZcRq;
        Thu, 10 Jun 2021 11:35:26 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 11:38:14 +0800
Received: from [10.67.77.175] (10.67.77.175) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 11:38:14 +0800
Subject: Re: [PATCH] scsi: lpfc: Remove the repeated declaration
To:     <linux-scsi@vger.kernel.org>
CC:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1622117381-35693-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <c7fb99ec-2944-f181-3ed6-1d080c66c31d@hisilicon.com>
Date:   Thu, 10 Jun 2021 11:38:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1622117381-35693-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

A gentle ping, sorry for the noise.

Thanks,
Shaokun

On 2021/5/27 20:09, Shaokun Zhang wrote:
> Function 'lpfc_selective_reset' is declared twice, so remove the
> repeated declaration.
> 
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Dick Kennedy <dick.kennedy@broadcom.com>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/scsi/lpfc/lpfc_crtn.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
> index 383abf46fd29..24927c58e97b 100644
> --- a/drivers/scsi/lpfc/lpfc_crtn.h
> +++ b/drivers/scsi/lpfc/lpfc_crtn.h
> @@ -509,7 +509,6 @@ void lpfc_sli_abts_recover_port(struct lpfc_vport *,
>  int lpfc_hba_init_link_fc_topology(struct lpfc_hba *, uint32_t, uint32_t);
>  int lpfc_issue_reg_vfi(struct lpfc_vport *);
>  int lpfc_issue_unreg_vfi(struct lpfc_vport *);
> -int lpfc_selective_reset(struct lpfc_hba *);
>  int lpfc_sli4_read_config(struct lpfc_hba *);
>  void lpfc_sli4_node_prep(struct lpfc_hba *);
>  int lpfc_sli4_els_sgl_update(struct lpfc_hba *phba);
> 
