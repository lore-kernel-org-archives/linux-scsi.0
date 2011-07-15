From: Davidlohr Bueso <dave.bueso@gmail.com>
Subject: [PATCH 16/16] SCSI: remove Scsi_Cmnd
Date: Fri, 15 Jul 2011 02:20:43 -0400
Message-ID: <1310710843.3184.67.camel@offbook>
Reply-To: dave@gnu.org
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60383 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121Ab1GOGWG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2011 02:22:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>

From: Davidlohr Bueso <dave@gnu.org>

Now that no driver is using this typedef, we can finally get rid of this ugly file.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/scsi.h          |    3 ---
 drivers/scsi/scsi_typedefs.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)
 delete mode 100644 drivers/scsi/scsi_typedefs.h

diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
index d5a55fa..db67d4c 100644
--- a/drivers/scsi/scsi.h
+++ b/drivers/scsi/scsi.h
@@ -42,7 +42,4 @@ struct scsi_device;
 struct scsi_target;
 struct scatterlist;
 
-/* obsolete typedef junk. */
-#include "scsi_typedefs.h"
-
 #endif /* _SCSI_H */
diff --git a/drivers/scsi/scsi_typedefs.h b/drivers/scsi/scsi_typedefs.h
deleted file mode 100644
index 2ed4c5c..0000000
--- a/drivers/scsi/scsi_typedefs.h
+++ /dev/null
@@ -1,2 +0,0 @@
-
-typedef struct scsi_cmnd Scsi_Cmnd;
-- 
1.7.4.1





