From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] configfs: change depends -> select SYSFS
Date: Mon, 10 Jan 2011 11:45:08 -0800
Message-ID: <1294688708-24986-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:47298 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754431Ab1AJTwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 14:52:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <joel.becker@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Joel,

This is a fix for linux-next that Randy reported over the holidays but has not
made it in just yet.   Please have a look and give your signoff at your earliest
convience.

Thanks!

----------------------------------------------------------------------------------

This patch changes configfs to select SYSFS to fix the following:

warning: (TARGET_CORE && GFS2_FS) selects CONFIGFS_FS which has unmet direct dependencies (SYSFS)

This patch also fixes whitespace breakage in the 'help' section.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 fs/configfs/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/configfs/Kconfig b/fs/configfs/Kconfig
index 13587cc..0e4bd23 100644
--- a/fs/configfs/Kconfig
+++ b/fs/configfs/Kconfig
@@ -1,11 +1,11 @@
 config CONFIGFS_FS
 	tristate "Userspace-driven configuration filesystem"
-	depends on SYSFS
+	select SYSFS
 	help
-	  configfs is a ram-based filesystem that provides the converse
-	  of sysfs's functionality. Where sysfs is a filesystem-based
-	  view of kernel objects, configfs is a filesystem-based manager
-	  of kernel objects, or config_items.
+	configfs is a RAM-based filesystem that provides the converse
+	of sysfs's functionality. Where sysfs is a filesystem-based
+	view of kernel objects, configfs is a filesystem-based manager
+	of kernel objects, or config_items.
 
-	  Both sysfs and configfs can and should exist together on the
-	  same system. One is not a replacement for the other.
+	Both sysfs and configfs can and should exist together on the
+	same system. One is not a replacement for the other.
-- 
1.7.3.5

