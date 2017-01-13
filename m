From: Fam Zheng <famz@redhat.com>
Subject: [PATCH] libfc: Fix variable name in fc_set_wwpn
Date: Fri, 13 Jan 2017 11:40:01 +0800
Message-ID: <20170113034001.29202-1-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: famz@redhat.com, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

The parameter name should be wwpn instead of wwnn.

Signed-off-by: Fam Zheng <famz@redhat.com>
---
 include/scsi/libfc.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
index 96dd0b3..da5033d 100644
--- a/include/scsi/libfc.h
+++ b/include/scsi/libfc.h
@@ -809,11 +809,11 @@ static inline void fc_set_wwnn(struct fc_lport *lport, u64 wwnn)
 /**
  * fc_set_wwpn() - Set the World Wide Port Name of a local port
  * @lport: The local port whose WWPN is to be set
- * @wwnn:  The new WWPN
+ * @wwpn:  The new WWPN
  */
-static inline void fc_set_wwpn(struct fc_lport *lport, u64 wwnn)
+static inline void fc_set_wwpn(struct fc_lport *lport, u64 wwpn)
 {
-	lport->wwpn = wwnn;
+	lport->wwpn = wwpn;
 }
 
 /**
-- 
2.9.3
