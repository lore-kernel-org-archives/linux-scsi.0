From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 14/14] target core v4.0.0-rc7-ml
Date: Fri, 25 Feb 2011 11:50:06 -0800
Message-ID: <1298663406-5118-15-git-send-email-nab@linux-iscsi.org>
References: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm6-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.206]:48767 "HELO
	nm6-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932644Ab1BYTut (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 14:50:49 -0500
In-Reply-To: <1298663406-5118-1-git-send-email-nab@linux-iscsi.org>
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
index b3a62e4..79f2e0a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -9,7 +9,7 @@
 #include <net/sock.h>
 #include <net/tcp.h>
 
-#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc6"
+#define TARGET_CORE_MOD_VERSION		"v4.0.0-rc7-ml"
 #define SHUTDOWN_SIGS	(sigmask(SIGKILL)|sigmask(SIGINT)|sigmask(SIGABRT))
 
 /* Used by transport_generic_allocate_iovecs() */
-- 
1.7.4.1

