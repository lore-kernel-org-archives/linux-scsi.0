From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 1/2] ufs: fix typo: MAZ to MAX
Date: Tue,  9 Feb 2016 10:25:40 +0200
Message-ID: <1455006341-1260-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:55275 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbcBII0q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Feb 2016 03:26:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <JBottomley@Parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

QUERY_DESC_GEOMETRY_MAZ_SIZE
QUERY_DESC_GEOMETRY_MAX_SIZE

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufs.h    | 2 +-
 drivers/scsi/ufs/ufshcd.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 42c459a9d3fe..54a16cef0367 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -170,7 +170,7 @@ enum ufs_desc_max_size {
 	 * of descriptor header.
 	 */
 	QUERY_DESC_STRING_MAX_SIZE		= 0xFE,
-	QUERY_DESC_GEOMETRY_MAZ_SIZE		= 0x44,
+	QUERY_DESC_GEOMETRY_MAX_SIZE		= 0x44,
 	QUERY_DESC_POWER_MAX_SIZE		= 0x62,
 	QUERY_DESC_RFU_MAX_SIZE			= 0x00,
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 85cd2564c157..a44153401aee 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -92,7 +92,7 @@ static u32 ufs_query_desc_max_size[] = {
 	QUERY_DESC_INTERCONNECT_MAX_SIZE,
 	QUERY_DESC_STRING_MAX_SIZE,
 	QUERY_DESC_RFU_MAX_SIZE,
-	QUERY_DESC_GEOMETRY_MAZ_SIZE,
+	QUERY_DESC_GEOMETRY_MAX_SIZE,
 	QUERY_DESC_POWER_MAX_SIZE,
 	QUERY_DESC_RFU_MAX_SIZE,
 };
-- 
2.4.3

