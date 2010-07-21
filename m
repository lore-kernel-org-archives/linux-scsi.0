From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 14/19] be2iscsi: The extend shift
Date: Thu, 22 Jul 2010 04:28:13 +0530
Message-ID: <20100721225803.GA9691@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:25547 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751679Ab0GUW55 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jul 2010 18:57:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  The extended shift must be 16

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_cmds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.h b/drivers/scsi/be2iscsi/be_cmds.h
index 0df19cb..40641d0 100644
--- a/drivers/scsi/be2iscsi/be_cmds.h
+++ b/drivers/scsi/be2iscsi/be_cmds.h
@@ -56,7 +56,7 @@ struct be_mcc_wrb {
 #define CQE_STATUS_COMPL_MASK 0xFFFF
 #define CQE_STATUS_COMPL_SHIFT 0	/* bits 0 - 15 */
 #define CQE_STATUS_EXTD_MASK 0xFFFF
-#define CQE_STATUS_EXTD_SHIFT 0		/* bits 0 - 15 */
+#define CQE_STATUS_EXTD_SHIFT 16		/* bits 0 - 15 */
 
 struct be_mcc_compl {
 	u32 status;		/* dword 0 */
-- 
1.6.5.2

