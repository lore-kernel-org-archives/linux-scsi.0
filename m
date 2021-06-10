Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8F73C48BCD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:27:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B55F861418
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 03:27:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229951AbhFJD3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 23:29:40 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:5365 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhFJD3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 23:29:40 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4G0q7p1tM3z6vPf;
        Thu, 10 Jun 2021 11:23:50 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 10 Jun 2021 11:27:42 +0800
Received: from [10.67.77.175] (10.67.77.175) by dggpeml500023.china.huawei.com
 (7.185.36.114) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 10 Jun
 2021 11:27:42 +0800
Subject: Re: [PATCH] scsi: qla2xxx: Remove the repeated declaration
To:     <linux-scsi@vger.kernel.org>
CC:     Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1621843402-34828-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
Message-ID: <68bf5968-a3a7-b514-4e8c-9fdd1e0e23dc@hisilicon.com>
Date:   Thu, 10 Jun 2021 11:27:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1621843402-34828-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.77.175]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

A gentle ping, sorry for the noise.

Thanks,
Shaokun

On 2021/5/24 16:03, Shaokun Zhang wrote:
> Functions 'qla2x00_post_uevent_work', 'qla2x00_free_fcport' and
> variable 'ql2xexlogins' are declared twice, remove the repeated
> declaration.
> 
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: GR-QLogic-Storage-Upstream@marvell.com
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com> 
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---
>  drivers/scsi/qla2xxx/qla_gbl.h | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
> index fae5cae6f0a8..418be9a2fcf6 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -173,7 +173,6 @@ extern int ql2xnvmeenable;
>  extern int ql2xautodetectsfp;
>  extern int ql2xenablemsix;
>  extern int qla2xuseresexchforels;
> -extern int ql2xexlogins;
>  extern int ql2xdifbundlinginternalbuffers;
>  extern int ql2xfulldump_on_mpifail;
>  extern int ql2xenforce_iocb_limit;
> @@ -220,7 +219,6 @@ extern int qla83xx_set_drv_presence(scsi_qla_host_t *vha);
>  extern int __qla83xx_set_drv_presence(scsi_qla_host_t *vha);
>  extern int qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
>  extern int __qla83xx_clear_drv_presence(scsi_qla_host_t *vha);
> -extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
>  
>  extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
>  extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
> @@ -687,8 +685,6 @@ extern int qla2x00_chk_ms_status(scsi_qla_host_t *, ms_iocb_entry_t *,
>  	struct ct_sns_rsp *, const char *);
>  extern void qla2x00_async_iocb_timeout(void *data);
>  
> -extern void qla2x00_free_fcport(fc_port_t *);
> -
>  extern int qla24xx_post_gpnid_work(struct scsi_qla_host *, port_id_t *);
>  extern int qla24xx_async_gpnid(scsi_qla_host_t *, port_id_t *);
>  void qla24xx_handle_gpnid_event(scsi_qla_host_t *, struct event_arg *);
> 
