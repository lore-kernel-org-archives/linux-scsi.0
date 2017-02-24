From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v3 14/14] qla2xxx: Update driver version to 9.00.00.00-k
Date: Fri, 24 Feb 2017 13:37:43 -0800
Message-ID: <1487972263-3795-15-git-send-email-himanshu.madhani@cavium.com>
References: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1487972263-3795-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, Bart.VanAssche@sandisk.com, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/qla_version.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 3cb1964..45bc84e 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.07.00.38-k"
+#define QLA2XXX_VERSION      "9.00.00.00-k"
 
-#define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	7
+#define QLA_DRIVER_MAJOR_VER	9
+#define QLA_DRIVER_MINOR_VER	0
 #define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
-- 
1.8.3.1
