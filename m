From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 16/31] target core v4.0.0-rc7
Date: Wed,  9 Feb 2011 15:34:51 -0800
Message-ID: <1297294506-23579-17-git-send-email-nab@linux-iscsi.org>
References: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.240]:39509 "HELO
	nm11-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756024Ab1BIXfh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:35:37 -0500
In-Reply-To: <1297294506-23579-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 include/target/target_core_base.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c071907..51bd709 100644
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
1.7.4

