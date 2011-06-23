From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH 15/37] Remove unneeded version.h includes from
 drivers/target/
Date: Fri, 24 Jun 2011 00:30:35 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1106240029310.17688@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: trivial@kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <jbottomley@parallels.com>, Kiran Patil <kiran.patil@intel.com>, Yi Zou <yi.zou@intel.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

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
index 47abb42..5c5b85a 100644
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
index ee6fad9..c02d4ec 100644
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
index 07ab5a3..2f6b7f9 100644
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
index 150c430..dd6b96e 100644
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
index 8663900..32c372b 100644
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
index a79f518..98cf0e1 100644
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
index 331d423..79f35e4 100644
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
index 7837dd3..adbda89 100644
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
index 5e3a067..889c64e 100644
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
index 59b8b9c..c1ab4e0 100644
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
index 4dafeb8..d947309 100644
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
index df35517..d8434b4 100644
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
index c056a11..580976b 100644
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
index 84e868c..fa3c86a 100644
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
index 4c3c0ef..739f9fc 100644
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
index a3bd57f..f09a6a4 100644
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
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
