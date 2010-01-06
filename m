From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 2/3] be2iscsi: Fixing the number of SGE's
Date: Thu, 7 Jan 2010 01:51:04 +0530
Message-ID: <20100106202052.GA19928@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:26892 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754683Ab0AFUUk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2010 15:20:40 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	The number of SGE's supported is fixed to what the
chip expects. Also, the max sectors set to tested values

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 4cde8f6..13ff02c 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -56,10 +56,10 @@
 #define BE2_DEFPDU_DATA_SZ	8192
 
 #define MAX_CPUS		31
-#define BEISCSI_SGLIST_ELEMENTS	BE2_SGE
+#define BEISCSI_SGLIST_ELEMENTS	30
 
 #define BEISCSI_CMD_PER_LUN	128	/* scsi_host->cmd_per_lun */
-#define BEISCSI_MAX_SECTORS	2048	/* scsi_host->max_sectors */
+#define BEISCSI_MAX_SECTORS	256	/* scsi_host->max_sectors */
 
 #define BEISCSI_MAX_CMD_LEN	16	/* scsi_host->max_cmd_len */
 #define BEISCSI_NUM_MAX_LUN	256	/* scsi_host->max_lun */
-- 
1.6.4

