From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 17/19] qla2xxx: Clear options-flags while staging firmware-execution.
Date: Thu, 20 Sep 2007 14:07:48 -0700
Message-ID: <1190322470-15543-17-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbXITVHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:41 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index ec48871..c53ec67 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -391,7 +391,8 @@ qla2x00_execute_fw(scsi_qla_host_t *ha, uint32_t risc_addr)
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
-		mcp->out_mb |= MBX_3|MBX_2|MBX_1;
+		mcp->mb[4] = 0;
+		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
 		mcp->in_mb |= MBX_1;
 	} else {
 		mcp->mb[1] = LSW(risc_addr);
-- 
1.5.3.2.80.g077d6f

