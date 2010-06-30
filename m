From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 08/12] be2iscsi: The extend shift
Date: Wed, 30 Jun 2010 05:31:07 +0530
Message-ID: <20100630000055.GA20300@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34492 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754065Ab0F3AA5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:00:57 -0400
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
index 18915a6..0176422 100644
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

