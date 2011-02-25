From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 04/14] target: remove EXTRA_CFLAGS
Date: Fri, 25 Feb 2011 11:49:56 -0800
Message-ID: <1298663406-5118-5-git-send-email-nab@linux-iscsi.org>
References: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26.bullet.mail.sp2.yahoo.com ([98.139.91.96]:39994 "HELO
	nm26.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTu2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:28 -0500
In-Reply-To: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Christoph Hellwig <hch@lst.de>

Add the current directory is superflous in general, and no includes in
drivers/scsi are needed either.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 973bb19..050ee65 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,4 +1,3 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
 
 target_core_mod-y		:= target_core_configfs.o \
 				   target_core_device.o \
-- 
1.7.4.1

