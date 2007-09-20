From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 13/19] qla2xxx: Remove unused member (list) from srb_t structure.
Date: Thu, 20 Sep 2007 14:07:44 -0700
Message-ID: <1190322470-15543-13-git-send-email-andrew.vasquez@qlogic.com>
References: <20070920210422.GE8456@plap3.qlogic.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:11180 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbXITVH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:07:58 -0400
In-Reply-To: <20070920210422.GE8456@plap3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

This change reduces by as much as 16% the memory footprint for
each allocated sbr_t structure requested from the mempool.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 1396f4d..b928e31 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -185,8 +185,6 @@
  * SCSI Request Block
  */
 typedef struct srb {
-	struct list_head list;
-
 	struct scsi_qla_host *ha;	/* HA the SP is queued on */
 	struct fc_port *fcport;
 
-- 
1.5.3.2.80.g077d6f

