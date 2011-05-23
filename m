From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
Date: Mon, 23 May 2011 14:10:32 -0700
Message-ID: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-next <linux-next@vger.kernel.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 20be668..16e9861 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6032,6 +6032,17 @@ F:	Documentation/filesystems/sysv-fs.txt
 F:	fs/sysv/
 F:	include/linux/sysv_fs.h
 
+TARGET SUBSYSTEM
+M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
+L:	linux-scsi@vger.kernel.org
+L:	http://groups.google.com/group/linux-iscsi-target-dev
+W:	http://www.linux-iscsi.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
+S:	Supported
+F:	drivers/target/
+F:	include/target/
+F:	Documentation/target/
+
 TASKSTATS STATISTICS INTERFACE
 M:	Balbir Singh <balbir@linux.vnet.ibm.com>
 S:	Maintained
-- 
1.7.5.2
