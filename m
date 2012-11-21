From: David Howells <dhowells@redhat.com>
Subject: [PATCH] UAPI: (Scripted) Disintegrate include/scsi
Date: Wed, 21 Nov 2012 15:32:13 +0000
Message-ID: <20121121152930.9141.80561.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Dave Jones <davej@redhat.com>
---

 include/scsi/Kbuild                 |    3 ---
 include/uapi/scsi/Kbuild            |    3 +++
 include/uapi/scsi/scsi_bsg_fc.h     |    0 
 include/uapi/scsi/scsi_netlink.h    |    0 
 include/uapi/scsi/scsi_netlink_fc.h |    0 
 5 files changed, 3 insertions(+), 3 deletions(-)
 rename include/{scsi/scsi_bsg_fc.h => uapi/scsi/scsi_bsg_fc.h} (100%)
 rename include/{scsi/scsi_netlink.h => uapi/scsi/scsi_netlink.h} (100%)
 rename include/{scsi/scsi_netlink_fc.h => uapi/scsi/scsi_netlink_fc.h} (100%)

diff --git a/include/scsi/Kbuild b/include/scsi/Kbuild
index f2b9491..562ff9d 100644
--- a/include/scsi/Kbuild
+++ b/include/scsi/Kbuild
@@ -1,4 +1 @@
-header-y += scsi_netlink.h
-header-y += scsi_netlink_fc.h
-header-y += scsi_bsg_fc.h
 header-y += fc/
diff --git a/include/uapi/scsi/Kbuild b/include/uapi/scsi/Kbuild
index 29a87dd..75746d5 100644
--- a/include/uapi/scsi/Kbuild
+++ b/include/uapi/scsi/Kbuild
@@ -1,2 +1,5 @@
 # UAPI Header export list
 header-y += fc/
+header-y += scsi_bsg_fc.h
+header-y += scsi_netlink.h
+header-y += scsi_netlink_fc.h
diff --git a/include/scsi/scsi_bsg_fc.h b/include/uapi/scsi/scsi_bsg_fc.h
similarity index 100%
rename from include/scsi/scsi_bsg_fc.h
rename to include/uapi/scsi/scsi_bsg_fc.h
diff --git a/include/scsi/scsi_netlink.h b/include/uapi/scsi/scsi_netlink.h
similarity index 100%
rename from include/scsi/scsi_netlink.h
rename to include/uapi/scsi/scsi_netlink.h
diff --git a/include/scsi/scsi_netlink_fc.h b/include/uapi/scsi/scsi_netlink_fc.h
similarity index 100%
rename from include/scsi/scsi_netlink_fc.h
rename to include/uapi/scsi/scsi_netlink_fc.h
