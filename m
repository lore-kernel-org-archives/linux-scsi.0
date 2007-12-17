From: Joe Perches <joe@perches.com>
Subject: [PATCH] drivers/message/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:42 -0800
Message-ID: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe__18940.6375321143$1197921116$gmane$org@perches.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757428AbXLQTuF@vger.kernel.org>
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, MPT Fusion Linux Team <DL-MPTFusionLinux@lsi.com>, linux-scsi@vger.kernel.org, support@lsi.com
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/message/fusion/mptctl.c   |    8 ++++----
 drivers/message/fusion/mptscsih.c |    2 +-
 drivers/message/i2o/iop.c         |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 6029509..e630b50 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1708,7 +1708,7 @@ mptctl_replace_fw (unsigned long arg)
  *
  * Outputs:	None.
  * Return:	0 if successful
- *		-EBUSY  if previous command timout and IOC reset is not complete.
+ *		-EBUSY  if previous command timeout and IOC reset is not complete.
  *		-EFAULT if data unavailable
  *		-ENODEV if no such device/adapter
  *		-ETIME	if timer expires
@@ -1748,7 +1748,7 @@ mptctl_mpt_command (unsigned long arg)
  *
  * Outputs:	None.
  * Return:	0 if successful
- *		-EBUSY  if previous command timout and IOC reset is not complete.
+ *		-EBUSY  if previous command timeout and IOC reset is not complete.
  *		-EFAULT if data unavailable
  *		-ENODEV if no such device/adapter
  *		-ETIME	if timer expires
@@ -2316,7 +2316,7 @@ done_free_mem:
  * Outputs:	None.
  * Return:	0 if successful
  *		-EFAULT if data unavailable
- *		-EBUSY  if previous command timout and IOC reset is not complete.
+ *		-EBUSY  if previous command timeout and IOC reset is not complete.
  *		-ENODEV if no such device/adapter
  *		-ETIME	if timer expires
  *		-ENOMEM if memory allocation error
@@ -2553,7 +2553,7 @@ mptctl_hp_hostinfo(unsigned long arg, unsigned int data_size)
  * Outputs:	None.
  * Return:	0 if successful
  *		-EFAULT if data unavailable
- *		-EBUSY  if previous command timout and IOC reset is not complete.
+ *		-EBUSY  if previous command timeout and IOC reset is not complete.
  *		-ENODEV if no such device/adapter
  *		-ETIME	if timer expires
  *		-ENOMEM if memory allocation error
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index 626bb3c..7d3d2de 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1736,7 +1736,7 @@ mptscsih_IssueTaskMgmt(MPT_SCSI_HOST *hd, u8 type, u8 channel, u8 id, int lun, i
  fail_out:
 
 	/*
-	 * Free task managment mf, and corresponding tm flags
+	 * Free task management mf, and corresponding tm flags
 	 */
 	mpt_free_msg_frame(ioc, mf);
 	hd->tmPending = 0;
diff --git a/drivers/message/i2o/iop.c b/drivers/message/i2o/iop.c
index 7814a06..da715e1 100644
--- a/drivers/message/i2o/iop.c
+++ b/drivers/message/i2o/iop.c
@@ -916,7 +916,7 @@ static int i2o_parse_hrt(struct i2o_controller *c)
  *	status block. The status block could then be accessed through
  *	c->status_block.
  *
- *	Returns 0 on sucess or negative error code on failure.
+ *	Returns 0 on success or negative error code on failure.
  */
 int i2o_status_get(struct i2o_controller *c)
 {
-- 
1.5.3.7.949.g2221a6

