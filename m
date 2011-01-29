From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 13/24] target: remove EXTRA_CFLAGS
Date: Sat, 29 Jan 2011 10:36:13 -0800
Message-ID: <1296326184-16664-14-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm24-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.222]:40730 "HELO
	nm24-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754858Ab1A2Smf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:42:35 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

Add the current directory is superflous in general, and no includes in
drivers/scsi are needed either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit c524edaf2c19a5c1caa06a3cba97cdb043eb165c)
---
 drivers/target/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 5cfd708..ab3b40f 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,4 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
 
 target_core_mod-y		:= target_core_configfs.o \
 				   target_core_device.o \
-- 
1.7.3.5

