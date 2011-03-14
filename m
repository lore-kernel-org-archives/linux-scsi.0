From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 16/21] target core v4.0.0-rc7-ml
Date: Mon, 14 Mar 2011 04:06:10 -0700
Message-ID: <1300100775-10012-17-git-send-email-nab@linux-iscsi.org>
References: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1300100775-10012-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Joel Becker <jlbec@evilplan.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

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
