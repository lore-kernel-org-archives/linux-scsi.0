From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 03/10] qla2xxx: Set tcm_qla2xxx version to automatically track qla2xxx version.
Date: Wed, 21 Dec 2016 13:57:32 -0800
Message-ID: <1482357459-31079-4-git-send-email-himanshu.madhani@cavium.com>
References: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@cavium.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6643f6f..d925910 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1800,7 +1800,7 @@ static ssize_t tcm_qla2xxx_wwn_version_show(struct config_item *item,
 {
 	return sprintf(page,
 	    "TCM QLOGIC QLA2XXX NPIV capable fabric module %s on %s/%s on "
-	    UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
+	    UTS_RELEASE"\n", QLA2XXX_VERSION, utsname()->sysname,
 	    utsname()->machine);
 }
 
@@ -1906,7 +1906,7 @@ static int tcm_qla2xxx_register_configfs(void)
 	int ret;
 
 	pr_debug("TCM QLOGIC QLA2XXX fabric module %s on %s/%s on "
-	    UTS_RELEASE"\n", TCM_QLA2XXX_VERSION, utsname()->sysname,
+	    UTS_RELEASE"\n", QLA2XXX_VERSION, utsname()->sysname,
 	    utsname()->machine);
 
 	ret = target_register_template(&tcm_qla2xxx_ops);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 37e026a..cf8430b 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -1,7 +1,6 @@
 #include <target/target_core_base.h>
 #include <linux/btree.h>
 
-#define TCM_QLA2XXX_VERSION	"v0.1"
 /* length of ASCII WWPNs including pad */
 #define TCM_QLA2XXX_NAMELEN	32
 /*
-- 
1.8.3.1
