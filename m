From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 044/103] tcm_fc: Makefile cleanups
Date: Thu, 21 Jul 2011 00:07:56 -0700
Message-ID: <1311232135-6653-45-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm14.access.bullet.mail.sp2.yahoo.com ([98.139.44.141]:23200
	"HELO nm14.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003Ab1GUHEG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:06 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the unnecessary EXTRA_CFLAGS includes, and drops the
unused -DTCM_FC_DEBUG define.

Reported-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/tcm_fc/Makefile |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/target/tcm_fc/Makefile b/drivers/target/tcm_fc/Makefile
index 7a5c2b6..20b14bb 100644
--- a/drivers/target/tcm_fc/Makefile
+++ b/drivers/target/tcm_fc/Makefile
@@ -1,15 +1,6 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ \
-		-I$(srctree)/drivers/scsi/ \
-		-I$(srctree)/include/scsi/ \
-		-I$(srctree)/drivers/target/tcm_fc/
-
-tcm_fc-y +=	tfc_cmd.o \
-		tfc_conf.o \
-		tfc_io.o \
-		tfc_sess.o
+tcm_fc-y +=		tfc_cmd.o \
+			tfc_conf.o \
+			tfc_io.o \
+			tfc_sess.o
 
 obj-$(CONFIG_TCM_FC)	+= tcm_fc.o
-
-ifdef CONFIGFS_TCM_FC_DEBUG
-EXTRA_CFLAGS	+= -DTCM_FC_DEBUG
-endif
-- 
1.7.6

