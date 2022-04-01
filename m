Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4C44C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 07:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235431AbiDAHKG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 03:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235392AbiDAHKA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 03:10:00 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AAB22498A7
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 00:08:08 -0700 (PDT)
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220401070802epoutp04142691ec518c126f8c4255e679758c50~htAdsM9QT2616526165epoutp04U
        for <linux-scsi@vger.kernel.org>; Fri,  1 Apr 2022 07:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220401070802epoutp04142691ec518c126f8c4255e679758c50~htAdsM9QT2616526165epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1648796882;
        bh=SjVNELorl13yMoBbcdpcUxePmcPy0lt7Vr89b7mZtTg=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=XEpwiqnbaDd8WItJNlfT6jb9tC43AE0tjxJUEnXvx/rtKqLGtu2EGZ5nDKk5sFdI0
         YIHDtOnKy32EUG7S5wzHipjvwY3+TQnuPPdnU/5B4z0BWW2NYz/HJlhFjLgzyJlcEn
         lIfyjg0iEY5VqVUM0LEoYs8wPUOYGcUgmF6cWFOQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20220401070802epcas3p1fb8d3b6fa7878a3e8b640b6ab93cf6cf~htAdNSuJK1159511595epcas3p1d;
        Fri,  1 Apr 2022 07:08:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4KVB8K6zQMz4x9Q2; Fri,  1 Apr 2022 07:08:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 04/29] scsi: ufs: Remove ufshcd_lrb.sense_bufflen
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20220331223424.1054715-5-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01648796881971.JavaMail.epsvc@epcpadp4>
Date:   Fri, 01 Apr 2022 15:14:36 +0900
X-CMS-MailID: 20220401061436epcms2p580800d12062f387a216106766981ee1a
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220331223522epcas2p4f8f20c2ec00dbc6d5a7bf855a1dd7395
References: <20220331223424.1054715-5-bvanassche@acm.org>
        <20220331223424.1054715-1-bvanassche@acm.org>
        <CGME20220331223522epcas2p4f8f20c2ec00dbc6d5a7bf855a1dd7395@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,
>ufshcd_lrb.sense_bufflen is set but never read. Hence remove this struct
>member.
> 
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong Park

>---
> drivers/scsi/ufs/ufshcd.c | 3 ---
> drivers/scsi/ufs/ufshcd.h | 2 --
> 2 files changed, 5 deletions(-)
> 
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index c60519372b3b..e52e86b0b7a3 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -2789,7 +2789,6 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>         lrbp = &hba->lrb[tag];
>         WARN_ON(lrbp->cmd);
>         lrbp->cmd = cmd;
>-        lrbp->sense_bufflen = UFS_SENSE_SIZE;
>         lrbp->sense_buffer = cmd->sense_buffer;
>         lrbp->task_tag = tag;
>         lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
>@@ -2830,7 +2829,6 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
>                 struct ufshcd_lrb *lrbp, enum dev_cmd_type cmd_type, int tag)
> {
>         lrbp->cmd = NULL;
>-        lrbp->sense_bufflen = 0;
>         lrbp->sense_buffer = NULL;
>         lrbp->task_tag = tag;
>         lrbp->lun = 0; /* device management cmd is not specific to any LUN */
>@@ -6802,7 +6800,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
>         lrbp = &hba->lrb[tag];
>         WARN_ON(lrbp->cmd);
>         lrbp->cmd = NULL;
>-        lrbp->sense_bufflen = 0;
>         lrbp->sense_buffer = NULL;
>         lrbp->task_tag = tag;
>         lrbp->lun = 0;
>diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>index b2740b51a546..b6162b208d99 100644
>--- a/drivers/scsi/ufs/ufshcd.h
>+++ b/drivers/scsi/ufs/ufshcd.h
>@@ -182,7 +182,6 @@ struct ufs_pm_lvl_states {
>  * @ucd_req_dma_addr: UPIU request dma address for debug
>  * @cmd: pointer to SCSI command
>  * @sense_buffer: pointer to sense buffer address of the SCSI command
>- * @sense_bufflen: Length of the sense buffer
>  * @scsi_status: SCSI status of the command
>  * @command_type: SCSI, UFS, Query.
>  * @task_tag: Task tag of the command
>@@ -207,7 +206,6 @@ struct ufshcd_lrb {
> 
>         struct scsi_cmnd *cmd;
>         u8 *sense_buffer;
>-        unsigned int sense_bufflen;
>         int scsi_status;
> 
>         int command_type;
> 
