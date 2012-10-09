From: David Howells <dhowells@redhat.com>
Subject: [PATCH/GIT PULL] UAPI: (Scripted) Disintegrate include/scsi
Date: Tue, 09 Oct 2012 14:50:11 +0100
Message-ID: <31138.1349790611@warthog.procyon.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: dhowells@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This completes part of the Userspace API (UAPI) disintegration for which the
preparatory patches were pulled recently.  After these patches, userspace
headers will be segregated into:

	include/uapi/linux/.../foo.h

for the userspace interface stuff, and:

	include/linux/.../foo.h

for the strictly kernel internal stuff.

This patch can be pulled from:

	git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-scsi-20121009

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Dave Jones <davej@redhat.com>
---
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
