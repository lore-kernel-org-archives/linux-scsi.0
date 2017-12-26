From: Tomer Tayar <Tomer.Tayar@cavium.com>
Subject: [PATCH v2 net-next 4/4] qed*: Advance drivers' version to 8.33.0.20
Date: Tue, 26 Dec 2017 19:56:28 +0200
Message-ID: <1514310988-3030-5-git-send-email-Tomer.Tayar@cavium.com>
References: <1514310988-3030-1-git-send-email-Tomer.Tayar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1514310988-3030-1-git-send-email-Tomer.Tayar@cavium.com>
Sender: netdev-owner@vger.kernel.org
To: davem@davemloft.net, netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Ariel Elior <Ariel.Elior@cavium.com>, Chad Dupuis <Chad.Dupuis@cavium.com>, Manish Rangankar <Manish.Rangankar@cavium.com>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Ariel Elior <Ariel.Elior@cavium.com>
Signed-off-by: Chad Dupuis <Chad.Dupuis@cavium.com>
Signed-off-by: Manish Rangankar <Manish.Rangankar@cavium.com>
Signed-off-by: Tomer Tayar <Tomer.Tayar@cavium.com>
---
 drivers/net/ethernet/qlogic/qed/qed.h   | 8 ++++----
 drivers/net/ethernet/qlogic/qede/qede.h | 6 +++---
 drivers/scsi/qedf/qedf_version.h        | 8 ++++----
 drivers/scsi/qedi/qedi_version.h        | 8 ++++----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index 323c13f..6948855 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -52,10 +52,10 @@
 
 extern const struct qed_common_ops qed_common_ops_pass;
 
-#define QED_MAJOR_VERSION               8
-#define QED_MINOR_VERSION               10
-#define QED_REVISION_VERSION            11
-#define QED_ENGINEERING_VERSION 21
+#define QED_MAJOR_VERSION		8
+#define QED_MINOR_VERSION		33
+#define QED_REVISION_VERSION		0
+#define QED_ENGINEERING_VERSION		20
 
 #define QED_VERSION						 \
 	((QED_MAJOR_VERSION << 24) | (QED_MINOR_VERSION << 16) | \
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index 8a33651..8e01b53 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -52,9 +52,9 @@
 #include <linux/qed/qed_eth_if.h>
 
 #define QEDE_MAJOR_VERSION		8
-#define QEDE_MINOR_VERSION		10
-#define QEDE_REVISION_VERSION		10
-#define QEDE_ENGINEERING_VERSION	21
+#define QEDE_MINOR_VERSION		33
+#define QEDE_REVISION_VERSION		0
+#define QEDE_ENGINEERING_VERSION	20
 #define DRV_MODULE_VERSION __stringify(QEDE_MAJOR_VERSION) "."	\
 		__stringify(QEDE_MINOR_VERSION) "."		\
 		__stringify(QEDE_REVISION_VERSION) "."		\
diff --git a/drivers/scsi/qedf/qedf_version.h b/drivers/scsi/qedf/qedf_version.h
index 397b3b8..c247805 100644
--- a/drivers/scsi/qedf/qedf_version.h
+++ b/drivers/scsi/qedf/qedf_version.h
@@ -7,9 +7,9 @@
  *  this source tree.
  */
 
-#define QEDF_VERSION		"8.20.5.0"
+#define QEDF_VERSION		"8.33.0.20"
 #define QEDF_DRIVER_MAJOR_VER		8
-#define QEDF_DRIVER_MINOR_VER		20
-#define QEDF_DRIVER_REV_VER		5
-#define QEDF_DRIVER_ENG_VER		0
+#define QEDF_DRIVER_MINOR_VER		33
+#define QEDF_DRIVER_REV_VER		0
+#define QEDF_DRIVER_ENG_VER		20
 
diff --git a/drivers/scsi/qedi/qedi_version.h b/drivers/scsi/qedi/qedi_version.h
index d61e3ac..8a0e523 100644
--- a/drivers/scsi/qedi/qedi_version.h
+++ b/drivers/scsi/qedi/qedi_version.h
@@ -7,8 +7,8 @@
  * this source tree.
  */
 
-#define QEDI_MODULE_VERSION	"8.10.4.0"
+#define QEDI_MODULE_VERSION	"8.33.0.20"
 #define QEDI_DRIVER_MAJOR_VER		8
-#define QEDI_DRIVER_MINOR_VER		10
-#define QEDI_DRIVER_REV_VER		4
-#define QEDI_DRIVER_ENG_VER		0
+#define QEDI_DRIVER_MINOR_VER		33
+#define QEDI_DRIVER_REV_VER		0
+#define QEDI_DRIVER_ENG_VER		20
-- 
1.8.3.1
