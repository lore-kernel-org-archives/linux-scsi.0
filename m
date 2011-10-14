From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 01/37] target: Remove unneeded version.h includes
Date: Fri, 14 Oct 2011 00:41:33 +0000
Message-ID: <1318552929-13341-2-git-send-email-nab@linux-iscsi.org>
References: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1318552929-13341-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jesper Juhl <jj@chaosbits.net>
List-Id: linux-scsi@vger.kernel.org

From: Jesper Juhl <jj@chaosbits.net>

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/target/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_alua.c            |    1 -
 drivers/target/target_core_configfs.c        |    1 -
 drivers/target/target_core_fabric_configfs.c |    1 -
 drivers/target/target_core_file.c            |    1 -
 drivers/target/target_core_iblock.c          |    1 -
 drivers/target/target_core_pr.c              |    1 -
 drivers/target/target_core_pscsi.c           |    1 -
 drivers/target/target_core_rd.c              |    1 -
 drivers/target/target_core_stat.c            |    1 -
 drivers/target/target_core_tmr.c             |    1 -
 drivers/target/target_core_transport.c       |    1 -
 drivers/target/target_core_ua.c              |    1 -
 drivers/target/tcm_fc/tfc_cmd.c              |    1 -
 drivers/target/tcm_fc/tfc_conf.c             |    1 -
 drivers/target/tcm_fc/tfc_io.c               |    1 -
 drivers/target/tcm_fc/tfc_sess.c             |    1 -
 16 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 98c98a3..007c6c2 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -24,7 +24,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/configfs.h>
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index b2575d8..f37e2b9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 55bbe08..09b6f87 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index bc1b336..99c9db0 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -26,7 +26,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 7e12341..7f0cc53 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -27,7 +27,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 7fd3a16..0c4f783 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -25,7 +25,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 2b7b0da..77d7258 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -26,7 +26,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index e567e12..1ab69f3 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -27,7 +27,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/string.h>
 #include <linux/parser.h>
 #include <linux/timer.h>
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index a8d6e1d..874152a 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -32,7 +32,6 @@
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/string.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/proc_fs.h>
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 27d4925..662473c 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -24,7 +24,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index a4b0a8d..4b2d6bf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -26,7 +26,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/net.h>
 #include <linux/delay.h>
 #include <linux/string.h>
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index 31e3c65..50a480d 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -24,7 +24,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <scsi/scsi.h>
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 80fbcde..3c6c5a1 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/tcm_fc/tfc_conf.c b/drivers/target/tcm_fc/tfc_conf.c
index 8fa39b7..b30eace 100644
--- a/drivers/target/tcm_fc/tfc_conf.c
+++ b/drivers/target/tcm_fc/tfc_conf.c
@@ -23,7 +23,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index d35ea5a..1369b1c 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -28,7 +28,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index dbb5eae..3269213 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/version.h>
 #include <generated/utsrelease.h>
 #include <linux/utsname.h>
 #include <linux/init.h>
-- 
1.5.6.5
