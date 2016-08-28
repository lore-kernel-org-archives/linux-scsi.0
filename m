From: Colin King <colin.king@canonical.com>
Subject: [PATCH] qla2xxx: fix spelling mistake "retyring" -> "retrying"
Date: Sun, 28 Aug 2016 12:24:48 +0100
Message-ID: <20160828112448.10785-1-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistakes in ql_dbg messages.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1dd8650..ace65db 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4694,7 +4694,7 @@ retry_unlock:
 			qla83xx_wait_logic();
 			retry++;
 			ql_dbg(ql_dbg_p3p, base_vha, 0xb064,
-			    "Failed to release IDC lock, retyring=%d\n", retry);
+			    "Failed to release IDC lock, retrying=%d\n", retry);
 			goto retry_unlock;
 		}
 	} else if (retry < 10) {
@@ -4702,7 +4702,7 @@ retry_unlock:
 		qla83xx_wait_logic();
 		retry++;
 		ql_dbg(ql_dbg_p3p, base_vha, 0xb065,
-		    "Failed to read drv-lockid, retyring=%d\n", retry);
+		    "Failed to read drv-lockid, retrying=%d\n", retry);
 		goto retry_unlock;
 	}
 
@@ -4718,7 +4718,7 @@ retry_unlock2:
 			qla83xx_wait_logic();
 			retry++;
 			ql_dbg(ql_dbg_p3p, base_vha, 0xb066,
-			    "Failed to release IDC lock, retyring=%d\n", retry);
+			    "Failed to release IDC lock, retrying=%d\n", retry);
 			goto retry_unlock2;
 		}
 	}
-- 
2.9.3
