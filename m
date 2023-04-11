Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0120C7619A
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 10:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDKKSf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 06:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjDKKSd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 06:18:33 -0400
Received: from michel.telenet-ops.be (michel.telenet-ops.be [IPv6:2a02:1800:110:4::f00:18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2958DE44
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 03:18:23 -0700 (PDT)
Received: from ramsan.of.borg ([84.195.187.55])
        by michel.telenet-ops.be with bizsmtp
        id jNJM2900K1C8whw06NJMu1; Tue, 11 Apr 2023 12:18:22 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtp (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pmB46-00GaZK-Oy;
        Tue, 11 Apr 2023 12:18:21 +0200
Received: from geert by rox.of.borg with local (Exim 4.95)
        (envelope-from <geert@linux-m68k.org>)
        id 1pmB4v-00EHAB-Qp;
        Tue, 11 Apr 2023 12:18:21 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "Manoj N . Kumar" <manoj@linux.ibm.com>,
        "Matthew R . Ochs" <mrochs@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] scsi: Spelling s/semahpore/semaphore/
Date:   Tue, 11 Apr 2023 12:18:20 +0200
Message-Id: <d7d04004b818d7ab5d62002f286b0a1b0b493193.1681208251.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix misspellings of "semaphore".

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/scsi/cxlflash/superpipe.c | 2 +-
 drivers/scsi/cxlflash/vlun.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/cxlflash/superpipe.c b/drivers/scsi/cxlflash/superpipe.c
index 22cfc2e1dfb938d4..e1b55b03e81243b4 100644
--- a/drivers/scsi/cxlflash/superpipe.c
+++ b/drivers/scsi/cxlflash/superpipe.c
@@ -358,7 +358,7 @@ static int read_cap16(struct scsi_device *sdev, struct llun_info *lli)
 	dev_dbg(dev, "%s: %ssending cmd(%02x)\n", __func__,
 		retry_cnt ? "re" : "", scsi_cmd[0]);
 
-	/* Drop the ioctl read semahpore across lengthy call */
+	/* Drop the ioctl read semaphore across lengthy call */
 	up_read(&cfg->ioctl_rwsem);
 	result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_IN, cmd_buf,
 				  CMD_BUFSIZE, to, CMD_RETRIES, &exec_args);
diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
index 9caabf5504362cb2..cbd5a648a131be64 100644
--- a/drivers/scsi/cxlflash/vlun.c
+++ b/drivers/scsi/cxlflash/vlun.c
@@ -448,7 +448,7 @@ static int write_same16(struct scsi_device *sdev,
 		put_unaligned_be32(ws_limit < left ? ws_limit : left,
 				   &scsi_cmd[10]);
 
-		/* Drop the ioctl read semahpore across lengthy call */
+		/* Drop the ioctl read semaphore across lengthy call */
 		up_read(&cfg->ioctl_rwsem);
 		result = scsi_execute_cmd(sdev, scsi_cmd, REQ_OP_DRV_OUT,
 					  cmd_buf, CMD_BUFSIZE, to,
-- 
2.34.1

