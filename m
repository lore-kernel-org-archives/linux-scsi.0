From: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 6/7] scsi/aic7xxx_old/aic7xxx.reg Typo change desciptor to descriptor.
Date: Fri, 31 Dec 2010 09:40:02 -0800
Message-ID: <1293817202-8115-1-git-send-email-justinmattock@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: trivial@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Justin P. Mattock" <justinmattock@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Below is a patch, that changes a typo from "desciptor" to "descriptor".
Let me know if I missed anything.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/aic7xxx_old/aic7xxx.reg |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic7xxx_old/aic7xxx.reg b/drivers/scsi/aic7xxx_old/aic7xxx.reg
index f67b4bc..13a7379 100644
--- a/drivers/scsi/aic7xxx_old/aic7xxx.reg
+++ b/drivers/scsi/aic7xxx_old/aic7xxx.reg
@@ -1296,7 +1296,7 @@ scratch_ram {
 	}
 	/*
 	 * Offset into the command descriptor array for the next
-	 * available desciptor to use.
+	 * available descriptor to use.
 	 */
 	TMODE_CMDADDR_NEXT {
 		size		1
-- 
1.6.5.2.180.gc5b3e
