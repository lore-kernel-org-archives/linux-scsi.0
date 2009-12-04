From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 09/15] be2iscsi: The alloc_wrb_handle does not use index
Date: Fri, 4 Dec 2009 08:54:03 +0530
Message-ID: <20091204032353.GA6203@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:6852 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754618AbZLDDXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2009 22:23:48 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch removes index from alloc_wrb_index

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 0e2eac6..388bd58 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -651,8 +651,8 @@ struct amap_iscsi_wrb {
 
 } __packed;
 
-struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid,
-				    int index);
+struct wrb_handle *alloc_wrb_handle(struct beiscsi_hba *phba, unsigned int cid);
+
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
-- 
1.6.4

