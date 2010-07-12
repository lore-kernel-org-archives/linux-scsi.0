From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 19/20] be2iscsi: Increase max sector
Date: Mon, 12 Jul 2010 23:31:01 +0530
Message-ID: <20100712180050.GA11898@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34499 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756319Ab0GLSA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jul 2010 14:00:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch increases the max_sectors to 2048

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index f5106df..703736b 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -63,7 +63,7 @@
 #define BEISCSI_SGLIST_ELEMENTS	30
 
 #define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
-#define BEISCSI_MAX_SECTORS	256	/* scsi_host->max_sectors */
+#define BEISCSI_MAX_SECTORS	2048	/* scsi_host->max_sectors */
 
 #define BEISCSI_MAX_CMD_LEN	16	/* scsi_host->max_cmd_len */
 #define BEISCSI_NUM_MAX_LUN	256	/* scsi_host->max_lun */
-- 
1.6.5.2

