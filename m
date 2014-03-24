From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH trivial 1/3] megaraid_sas: Spelling s/intance/instance/
Date: Mon, 24 Mar 2014 21:37:01 +0100
Message-ID: <1395693423-5134-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert+renesas@glider.be>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |    2 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3b7ad10497fe..10082678077c 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3865,7 +3865,7 @@ fail_ready_state:
 
 /**
  * megasas_release_mfi -	Reverses the FW initialization
- * @intance:			Adapter soft state
+ * @instance:			Adapter soft state
  */
 static void megasas_release_mfi(struct megasas_instance *instance)
 {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index f6555921fd7a..f7d68f65f974 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2164,7 +2164,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 
 /**
  * megasas_release_fusion -	Reverses the FW initialization
- * @intance:			Adapter soft state
+ * @instance:			Adapter soft state
  */
 void
 megasas_release_fusion(struct megasas_instance *instance)
-- 
1.7.9.5
