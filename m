Return-Path: <SRS0=GUYw=3P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA474C2D0DB
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 15:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6FE22071A
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 15:48:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgAZPsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jan 2020 10:48:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:33107 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgAZPsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jan 2020 10:48:01 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1ivk8j-00014y-8F; Sun, 26 Jan 2020 15:47:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: megaraid_sas: fix indentation issue
Date:   Sun, 26 Jan 2020 15:47:57 +0000
Message-Id: <20200126154757.42530-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two statments that are indented one level too deeply, remove
the extraneous tabs.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index acb82181f70f..b0a413ee75d5 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8226,8 +8226,8 @@ megasas_mgmt_fw_ioctl(struct megasas_instance *instance,
 			"return -EBUSY from %s %d cmd 0x%x opcode 0x%x cmd->cmd_status_drv 0x%x\n",
 			 __func__, __LINE__, cmd->frame->hdr.cmd, opcode,
 			 cmd->cmd_status_drv);
-			error = -EBUSY;
-			goto out;
+		error = -EBUSY;
+		goto out;
 	}
 
 	cmd->sync_cmd = 0;
-- 
2.24.0

