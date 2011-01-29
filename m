From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 24/24] target core v4.0.0-rc7
Date: Sat, 29 Jan 2011 10:36:24 -0800
Message-ID: <1296326184-16664-25-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30.bullet.mail.ac4.yahoo.com ([98.139.52.227]:38476 "HELO
	nm30.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754838Ab1A2ShV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:37:21 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit fbd8b6ab80e7316838a31ed2f4c99aa3cd3c47e7)
---
 include/target/target_core_base.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ba77c11..574bafd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -9,7 +9,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 
-#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc6"
+#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc7"
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
 
 /* Used by transport_generic_allocate_iovecs() */
-- 
1.7.3.5

