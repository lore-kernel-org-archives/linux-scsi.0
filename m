From: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scsi:fcoe: Fix typo "a ethernet" in fcoe_transport.c
Date: Thu,  4 Jun 2015 00:54:34 +0900
Message-ID: <1433346874-11261-1-git-send-email-standby24x7@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, trivial@kernel.org, vasu.dev@intel.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org
Cc: Masanari Iida <standby24x7@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch fix some "a ethernet" in MODULE_DESCRIPTIONS in
fcoe_transport.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/fcoe/fcoe_transport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index bdc8989..d7597c0 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -58,7 +58,7 @@ MODULE_PARM_DESC(show, " Show attached FCoE transports");
 module_param_call(create, fcoe_transport_create, NULL,
 		  (void *)FIP_MODE_FABRIC, S_IWUSR);
 __MODULE_PARM_TYPE(create, "string");
-MODULE_PARM_DESC(create, " Creates fcoe instance on a ethernet interface");
+MODULE_PARM_DESC(create, " Creates fcoe instance on an ethernet interface");
 
 module_param_call(create_vn2vn, fcoe_transport_create, NULL,
 		  (void *)FIP_MODE_VN2VN, S_IWUSR);
@@ -68,15 +68,15 @@ MODULE_PARM_DESC(create_vn2vn, " Creates a VN_node to VN_node FCoE instance "
 
 module_param_call(destroy, fcoe_transport_destroy, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(destroy, "string");
-MODULE_PARM_DESC(destroy, " Destroys fcoe instance on a ethernet interface");
+MODULE_PARM_DESC(destroy, " Destroys fcoe instance on an ethernet interface");
 
 module_param_call(enable, fcoe_transport_enable, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(enable, "string");
-MODULE_PARM_DESC(enable, " Enables fcoe on a ethernet interface.");
+MODULE_PARM_DESC(enable, " Enables fcoe on an ethernet interface.");
 
 module_param_call(disable, fcoe_transport_disable, NULL, NULL, S_IWUSR);
 __MODULE_PARM_TYPE(disable, "string");
-MODULE_PARM_DESC(disable, " Disables fcoe on a ethernet interface.");
+MODULE_PARM_DESC(disable, " Disables fcoe on an ethernet interface.");
 
 /* notification function for packets from net device */
 static struct notifier_block libfcoe_notifier = {
-- 
2.4.2.387.gf86f31a
