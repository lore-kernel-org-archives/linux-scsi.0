Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B5EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 11:54:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4942076C
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 11:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgHCLyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 07:54:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41710 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726624AbgHCLyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 3 Aug 2020 07:54:22 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9EFB1DF5C1EA0A586B97;
        Mon,  3 Aug 2020 19:38:00 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Mon, 3 Aug 2020 19:37:52 +0800
From:   chenxiang <chenxiang66@hisilicon.com>
To:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>
Subject: [PATCH] scsi: scsi_transport_sas: add spaces around binary operator "|"
Date:   Mon, 3 Aug 2020 19:34:02 +0800
Message-ID: <1596454442-220565-1-git-send-email-chenxiang66@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

According to coding style, need to use one space around binary operator "|",
so add spaces around it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/scsi_transport_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 182fd25..d1c0a21 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1526,7 +1526,7 @@ int sas_rphy_add(struct sas_rphy *rphy)
 	list_add_tail(&rphy->list, &sas_host->rphy_list);
 	if (identify->device_type == SAS_END_DEVICE &&
 	    (identify->target_port_protocols &
-	     (SAS_PROTOCOL_SSP|SAS_PROTOCOL_STP|SAS_PROTOCOL_SATA)))
+	     (SAS_PROTOCOL_SSP | SAS_PROTOCOL_STP | SAS_PROTOCOL_SATA)))
 		rphy->scsi_target_id = sas_host->next_target_id++;
 	else if (identify->device_type == SAS_END_DEVICE)
 		rphy->scsi_target_id = -1;
-- 
2.8.1

