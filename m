From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 15/19] qla2xxx: Cleanup several 'sparse' warnings.
Date: Thu, 20 Sep 2007 14:07:46 -0700
Message-ID: <1190322470-15543-15-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbXITVH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:58 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 3a5e78c..7f6a89b 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -308,7 +308,7 @@ qla2x00_start_scsi(srb_t *sp)
 		handle++;
 		if (handle == MAX_OUTSTANDING_COMMANDS)
 			handle = 1;
-		if (ha->outstanding_cmds[handle] == 0)
+		if (!ha->outstanding_cmds[handle])
 			break;
 	}
 	if (index == MAX_OUTSTANDING_COMMANDS)
@@ -711,7 +711,7 @@ qla24xx_start_scsi(srb_t *sp)
 		handle++;
 		if (handle == MAX_OUTSTANDING_COMMANDS)
 			handle = 1;
-		if (ha->outstanding_cmds[handle] == 0)
+		if (!ha->outstanding_cmds[handle])
 			break;
 	}
 	if (index == MAX_OUTSTANDING_COMMANDS)
-- 
1.5.3.2.80.g077d6f

