From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm_fc: Makefile cleanups
Date: Fri, 27 May 2011 14:41:01 -0700
Message-ID: <1306532463-28193-2-git-send-email-nab@linux-iscsi.org>
References: <1306532463-28193-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.access.bullet.mail.mud.yahoo.com ([66.94.237.202]:33664
	"HELO nm1.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752499Ab1E0VlK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 17:41:10 -0400
In-Reply-To: <1306532463-28193-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Kiran Patil <kiran.patil@intel.com>, Open-FCoE devel <devel@open-fcoe.org>, Nicholas Bellinger <nab@linux-iscsi.org>

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
1.7.5.3

