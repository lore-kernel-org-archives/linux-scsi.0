From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH][Resend] Remove unneeded version.h includes from
 drivers/target/
Date: Mon, 1 Aug 2011 23:29:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1108012327530.31999@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14735 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab1HAV3M (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 17:29:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <jbottomley@parallels.com>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, linux-scsi@vger.kernel.org

It was pointed out by 'make versioncheck' that some includes of
linux/version.h are not needed in drivers/target/.
This patch removes them.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
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
index f165469..3ba7512 100644
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
index 1c1b849..c05d93b 100644
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
index 3dd81d2..b43cc405 100644
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
index c75a01a..541b9d9 100644
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
index 09df38b..e095d81 100644
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
index 8781d1e..d526896 100644
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
index 8e2a46d..a4ae12f 100644
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
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

