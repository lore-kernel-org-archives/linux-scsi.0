From: David Howells <dhowells@redhat.com>
Subject: [PATCH/GIT PULL] UAPI: (Scripted) Disintegrate include/scsi/fc
Date: Tue, 09 Oct 2012 14:51:19 +0100
Message-ID: <31155.1349790679@warthog.procyon.org.uk>
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

	git://git.infradead.org/users/dhowells/linux-headers.git tags/disintegrate-fc-20121009

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Acked-by: Dave Jones <davej@redhat.com>
---
diff --git a/include/scsi/fc/Kbuild b/include/scsi/fc/Kbuild
index 5660381..e69de29 100644
--- a/include/scsi/fc/Kbuild
+++ b/include/scsi/fc/Kbuild
@@ -1,4 +0,0 @@
-header-y += fc_els.h
-header-y += fc_fs.h
-header-y += fc_gs.h
-header-y += fc_ns.h
diff --git a/include/uapi/scsi/fc/Kbuild b/include/uapi/scsi/fc/Kbuild
index aafaa5a..5ead9fa 100644
--- a/include/uapi/scsi/fc/Kbuild
+++ b/include/uapi/scsi/fc/Kbuild
@@ -1 +1,5 @@
 # UAPI Header export list
+header-y += fc_els.h
+header-y += fc_fs.h
+header-y += fc_gs.h
+header-y += fc_ns.h
diff --git a/include/scsi/fc/fc_els.h b/include/uapi/scsi/fc/fc_els.h
similarity index 100%
rename from include/scsi/fc/fc_els.h
rename to include/uapi/scsi/fc/fc_els.h
diff --git a/include/scsi/fc/fc_fs.h b/include/uapi/scsi/fc/fc_fs.h
similarity index 100%
rename from include/scsi/fc/fc_fs.h
rename to include/uapi/scsi/fc/fc_fs.h
diff --git a/include/scsi/fc/fc_gs.h b/include/uapi/scsi/fc/fc_gs.h
similarity index 100%
rename from include/scsi/fc/fc_gs.h
rename to include/uapi/scsi/fc/fc_gs.h
diff --git a/include/scsi/fc/fc_ns.h b/include/uapi/scsi/fc/fc_ns.h
similarity index 100%
rename from include/scsi/fc/fc_ns.h
rename to include/uapi/scsi/fc/fc_ns.h
