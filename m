From: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Subject: [PATCH 5/6] RFC: beiscsi: Makefile and Kconfig
Date: Mon, 27 Jul 2009 12:55:22 -0700
Message-ID: <1248724523-10999-6-git-send-email-jayamohank@serverengines.com>
References: <1248724523-10999-1-git-send-email-jayamohank@serverengines.com> <1248724523-10999-2-git-send-email-jayamohank@serverengines.com> <1248724523-10999-3-git-send-email-jayamohank@serverengines.com> <1248724523-10999-4-git-send-email-jayamohank@serverengines.com> <1248724523-10999-5-git-send-email-jayamohank@serverengines.com>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1248724523-10999-5-git-send-email-jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


  The Makefile and Kconfig for beiscsi driver

Signed-off-by: Jayamohan Kallickal <jayamohank-i5Eg4PDOvn3+uv41P6q33AC/G2K4zDHf@public.gmane.org>
---
 drivers/scsi/beiscsi/Kconfig  |    8 ++++++++
 drivers/scsi/beiscsi/Makefile |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/beiscsi/Kconfig
 create mode 100644 drivers/scsi/beiscsi/Makefile

diff --git a/drivers/scsi/beiscsi/Kconfig b/drivers/scsi/beiscsi/Kconfig
new file mode 100644
index 0000000..2952fcd
--- /dev/null
+++ b/drivers/scsi/beiscsi/Kconfig
@@ -0,0 +1,8 @@
+config BE2ISCSI
+	tristate "ServerEngines' 10Gbps iSCSI - BladeEngine 2"
+	depends on PCI && SCSI
+	select SCSI_ISCSI_ATTRS
+
+	help
+	This driver implements the iSCSI functionality for ServerEngines'
+	10Gbps Storage adapter - BladeEngine 2.
diff --git a/drivers/scsi/beiscsi/Makefile b/drivers/scsi/beiscsi/Makefile
new file mode 100644
index 0000000..c11f443
--- /dev/null
+++ b/drivers/scsi/beiscsi/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile to build the iSCSI driver for ServerEngine's BladeEngine.
+#
+#
+
+obj-$(CONFIG_BE2ISCSI) += be2iscsi.o
+
+be2iscsi-y := be_iscsi.o be_main.o be_mgmt.o be_cmds.o
-- 
1.6.3
