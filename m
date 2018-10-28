From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] scsi: qla2xxx: Fix a typo in MODULE_PARM_DESC
Date: Sun, 28 Oct 2018 14:05:48 +0900
Message-ID: <20181028050548.3147-1-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch fixes a spelling typo in MODULE_PARM_DESC
of ql2xplogiabsentdevice.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 8794e54f43a9..d9349408bf70 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -67,7 +67,7 @@ module_param(ql2xplogiabsentdevice, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"Option to enable PLOGI to devices that are not present after "
 		"a Fabric scan.  This is needed for several broken switches. "
-		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
+		"Default is 0 - no PLOGI. 1 - perform PLOGI.");
 
 int ql2xloginretrycount = 0;
 module_param(ql2xloginretrycount, int, S_IRUGO);
-- 
2.19.1.450.ga4b8ab5363a3
