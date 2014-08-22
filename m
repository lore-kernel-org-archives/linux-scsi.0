From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: target: target_core_ua_h: Add #define of include guard
Date: Fri, 22 Aug 2014 14:54:31 +0200
Message-ID: <1408712071-14474-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-Id: linux-scsi@vger.kernel.org

Clearly the file was meant to contain an include guard, but it was
missing the #define part.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/target/target_core_ua.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index be912b3..a6b56b3 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -1,4 +1,5 @@
 #ifndef TARGET_CORE_UA_H
+#define TARGET_CORE_UA_H
 
 /*
  * From spc4r17, Table D.1: ASC and ASCQ Assignement
-- 
1.9.2
