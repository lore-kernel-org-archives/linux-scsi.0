Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5C4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:36:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 966EA61058
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 22:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347727AbhIBWhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Sep 2021 18:37:45 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:33242
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347586AbhIBWho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2021 18:37:44 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id AA6B53F22D;
        Thu,  2 Sep 2021 22:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630622203;
        bh=ItSWBKpEcyPhijBkfmewmMxSZj7fC2HDkvdQMHVWVXY=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=uR1lXjluYE0eoxPlx0MmQ9y2le+SsrE78vD06IEMJQiWh9Zoi4probJ6CV+WuSXTU
         lmpAHoLmUitY5bVav6OWa8Ar2jWeyaoGAWq1Fd19u3A3pjgU/VOhkVQK2rUNBu/jXZ
         OdR5wKBgDWyKQ1FAaDfD6M2DlB72hqXOJ/jDo3CgyZ82iLgp3yFWOnwgpMeypBC1lh
         TR3ekeqR7Hd9Lh1qaLYHQXm3eYxORkME6K0yrTXm7B8sFtob/9fUffCL+F9V1nGLqy
         Wrcf6FZ6ThN6ivNo538EDtTCiUBprT4KEliXbkJOv+xCu/GGWiOsggWn/h2YSaWU+u
         T5cym8AzZgFrQ==
From:   Colin King <colin.king@canonical.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: megaraid: clean up some inconsistent indenting
Date:   Thu,  2 Sep 2021 23:36:43 +0100
Message-Id: <20210902223643.56979-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a few statements where the indentation is not correct,
clean these up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4298bf4a482..880b51a6f7dd 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1916,7 +1916,7 @@ void megasas_set_dynamic_target_properties(struct scsi_device *sdev,
 		raid = MR_LdRaidGet(ld, local_map_ptr);
 
 		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
-		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
+			blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
 
 		mr_device_priv_data->is_tm_capable =
 			raid->capability.tmCapable;
@@ -8033,7 +8033,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	if (instance->adapter_type != MFI_SERIES) {
 		megasas_release_fusion(instance);
-			pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
+		pd_seq_map_sz = sizeof(struct MR_PD_CFG_SEQ_NUM_SYNC) +
 				(sizeof(struct MR_PD_CFG_SEQ) *
 					(MAX_PHYSICAL_DEVICES - 1));
 		for (i = 0; i < 2 ; i++) {
-- 
2.32.0

