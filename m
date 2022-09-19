Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92F1ECAAD3
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Sep 2022 14:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbiISOVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Sep 2022 10:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiISOVS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Sep 2022 10:21:18 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2607F1AF1A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Sep 2022 07:21:16 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=gumi@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VQEjQFj_1663597268;
Received: from nu1m11355.sqa.nu8.tbsite.net(mailfrom:gumi@linux.alibaba.com fp:SMTPD_---0VQEjQFj_1663597268)
          by smtp.aliyun-inc.com;
          Mon, 19 Sep 2022 22:21:13 +0800
From:   Gu Mi <gumi@linux.alibaba.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        Gu Mi <gumi@linux.alibaba.com>
Subject: [PATCH] scsi: mpt3sas: add some indentation
Date:   Mon, 19 Sep 2022 22:21:07 +0800
Message-Id: <1663597267-79308-1-git-send-email-gumi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The line is indented too short, so it's a bit confusing.

Signed-off-by: Gu Mi <gumi@linux.alibaba.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index bd6a5f1..025c6c7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -10907,7 +10907,7 @@ void mpt3sas_scsih_pre_reset_handler(struct MPT3SAS_ADAPTER *ioc)
 			return 1;
 		break;
 	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
-	_scsih_check_pcie_topo_remove_events(ioc,
+		_scsih_check_pcie_topo_remove_events(ioc,
 		    (Mpi26EventDataPCIeTopologyChangeList_t *)
 		    mpi_reply->EventData);
 		if (ioc->shost_recovery)
-- 
1.8.3.1

