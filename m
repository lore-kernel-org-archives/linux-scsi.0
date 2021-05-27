Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58870C4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 12:09:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33236613C0
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 12:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhE0MLZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 08:11:25 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2437 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbhE0MLY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 08:11:24 -0400
Received: from dggeml763-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FrRPs0fgRz67cr;
        Thu, 27 May 2021 20:06:57 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggeml763-chm.china.huawei.com (10.1.199.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 27 May 2021 20:09:49 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 20:09:49 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-scsi@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] scsi: lpfc: Remove the repeated declaration
Date:   Thu, 27 May 2021 20:09:41 +0800
Message-ID: <1622117381-35693-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Function 'lpfc_selective_reset' is declared twice, so remove the
repeated declaration.

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 drivers/scsi/lpfc/lpfc_crtn.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
index 383abf46fd29..24927c58e97b 100644
--- a/drivers/scsi/lpfc/lpfc_crtn.h
+++ b/drivers/scsi/lpfc/lpfc_crtn.h
@@ -509,7 +509,6 @@ void lpfc_sli_abts_recover_port(struct lpfc_vport *,
 int lpfc_hba_init_link_fc_topology(struct lpfc_hba *, uint32_t, uint32_t);
 int lpfc_issue_reg_vfi(struct lpfc_vport *);
 int lpfc_issue_unreg_vfi(struct lpfc_vport *);
-int lpfc_selective_reset(struct lpfc_hba *);
 int lpfc_sli4_read_config(struct lpfc_hba *);
 void lpfc_sli4_node_prep(struct lpfc_hba *);
 int lpfc_sli4_els_sgl_update(struct lpfc_hba *phba);
-- 
2.7.4

