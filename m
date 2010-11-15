From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] target: rename Kbuild files to Makefile
Date: Mon, 15 Nov 2010 14:43:25 -0500
Message-ID: <20101115194325.GB23989@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59947 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab0KOTn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2010 14:43:26 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: lio-core/drivers/target/Kbuild
===================================================================
--- lio-core.orig/drivers/target/Kbuild	2010-11-15 20:28:49.340253390 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,31 +0,0 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
-
-target_core_mod-y		:= target_core_configfs.o \
-				   target_core_device.o \
-				   target_core_fabric_configfs.o \
-				   target_core_fabric_lib.o \
-				   target_core_hba.o \
-				   target_core_pr.o \
-				   target_core_alua.o \
-				   target_core_scdb.o \
-				   target_core_tmr.o \
-				   target_core_tpg.o \
-				   target_core_transport.o \
-				   target_core_cdb.o \
-				   target_core_ua.o \
-				   target_core_rd.o \
-				   target_core_mib.o
-
-obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
-
-# Subsystem modules
-obj-$(CONFIG_TCM_IBLOCK)	+= target_core_iblock.o
-obj-$(CONFIG_TCM_FILEIO)	+= target_core_file.o
-obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
-obj-$(CONFIG_TCM_STGT)		+= target_core_stgt.o
-
-# Fabric modules
-obj-$(CONFIG_LIO_TARGET)	+= lio-target/
-obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
-
-obj-$(CONFIG_TCM_FC)		+= tcm_fc/
Index: lio-core/drivers/target/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ lio-core/drivers/target/Makefile	2010-11-15 20:32:13.206003355 +0100
@@ -0,0 +1,31 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/
+
+target_core_mod-y		:= target_core_configfs.o \
+				   target_core_device.o \
+				   target_core_fabric_configfs.o \
+				   target_core_fabric_lib.o \
+				   target_core_hba.o \
+				   target_core_pr.o \
+				   target_core_alua.o \
+				   target_core_scdb.o \
+				   target_core_tmr.o \
+				   target_core_tpg.o \
+				   target_core_transport.o \
+				   target_core_cdb.o \
+				   target_core_ua.o \
+				   target_core_rd.o \
+				   target_core_mib.o
+
+obj-$(CONFIG_TARGET_CORE)	+= target_core_mod.o
+
+# Subsystem modules
+obj-$(CONFIG_TCM_IBLOCK)	+= target_core_iblock.o
+obj-$(CONFIG_TCM_FILEIO)	+= target_core_file.o
+obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
+obj-$(CONFIG_TCM_STGT)		+= target_core_stgt.o
+
+# Fabric modules
+obj-$(CONFIG_LIO_TARGET)	+= lio-target/
+obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop/
+
+obj-$(CONFIG_TCM_FC)		+= tcm_fc/
Index: lio-core/drivers/target/tcm_fc/Kbuild
===================================================================
--- lio-core.orig/drivers/target/tcm_fc/Kbuild	2010-11-15 20:32:27.637004333 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,16 +0,0 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ \
-		-I$(srctree)/drivers/scsi/ \
-		-I$(srctree)/include/scsi/ \
-		-I$(srctree)/drivers/target/tcm_fc/
-
-tcm_fc-objs := \
-		tfc_cmd.o \
-		tfc_conf.o \
-		tfc_io.o \
-		tfc_sess.o
-
-obj-$(CONFIG_TCM_FC)	+= tcm_fc.o
-
-ifdef CONFIGFS_TCM_FC_DEBUG
-EXTRA_CFLAGS	+= -DTCM_FC_DEBUG
-endif
Index: lio-core/drivers/target/tcm_fc/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ lio-core/drivers/target/tcm_fc/Makefile	2010-11-15 20:32:55.127016720 +0100
@@ -0,0 +1,15 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ \
+		-I$(srctree)/drivers/scsi/ \
+		-I$(srctree)/include/scsi/ \
+		-I$(srctree)/drivers/target/tcm_fc/
+
+tcm_fc-y +=	tfc_cmd.o \
+		tfc_conf.o \
+		tfc_io.o \
+		tfc_sess.o
+
+obj-$(CONFIG_TCM_FC)	+= tcm_fc.o
+
+ifdef CONFIGFS_TCM_FC_DEBUG
+EXTRA_CFLAGS	+= -DTCM_FC_DEBUG
+endif
Index: lio-core/drivers/target/tcm_loop/Kbuild
===================================================================
--- lio-core.orig/drivers/target/tcm_loop/Kbuild	2010-11-15 20:33:03.138261841 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,11 +0,0 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_loop/
-
-tcm_loop-objs			:= tcm_loop_fabric.o \
-				   tcm_loop_fabric_scsi.o \
-				   tcm_loop_configfs.o \
-
-obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop.o
-
-ifdef CONFIG_TCM_LOOP_CDB_DEBUG
-EXTRA_CFLAGS			+= -DTCM_LOOP_CDB_DEBUG
-endif
Index: lio-core/drivers/target/tcm_loop/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ lio-core/drivers/target/tcm_loop/Makefile	2010-11-15 20:33:14.072290333 +0100
@@ -0,0 +1,11 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/drivers/scsi/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/tcm_loop/
+
+tcm_loop-y			:= tcm_loop_fabric.o \
+				   tcm_loop_fabric_scsi.o \
+				   tcm_loop_configfs.o \
+
+obj-$(CONFIG_TCM_LOOP_FABRIC)	+= tcm_loop.o
+
+ifdef CONFIG_TCM_LOOP_CDB_DEBUG
+EXTRA_CFLAGS			+= -DTCM_LOOP_CDB_DEBUG
+endif
Index: lio-core/drivers/target/lio-target/Kbuild
===================================================================
--- lio-core.orig/drivers/target/lio-target/Kbuild	2010-11-15 20:33:29.942254717 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,37 +0,0 @@
-EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/lio-target
-
-EXTRA_CFLAGS+=-D_TARGET -DPYX_ISCSI_VENDOR='"Linux-iSCSI.org"'
-
-iscsi_target_mod-objs		:=	iscsi_auth_chap.o \
-					iscsi_debug_opcodes.o \
-					iscsi_parameters.o \
-					iscsi_seq_and_pdu_list.o \
-					iscsi_serial.o \
-					iscsi_thread_queue.o \
-					iscsi_target_datain_values.o \
-					iscsi_target_device.o \
-					iscsi_target_discovery.o \
-					iscsi_target_erl0.o \
-					iscsi_target_erl1.o \
-					iscsi_target_erl2.o \
-					iscsi_target_login.o \
-					iscsi_target_nego.o \
-					iscsi_target_nodeattrib.o \
-					iscsi_target_tmr.o \
-					iscsi_target_tpg.o \
-					iscsi_target_util.o \
-					iscsi_target.o \
-					iscsi_target_configfs.o \
-					iscsi_target_mib.o
-
-ifdef CONFIG_LIO_TARGET_DEBUG_ERL
-iscsi_target_mod-objs		+= iscsi_target_debugerl.o
-EXTRA_CFLAGS			+= -DDEBUG_ERL
-endif
-
-ifdef CONFIG_LIO_TARGET_DEBUG
-EXTRA_CFLAGS			+= -DCONFIG_ISCSI_DEBUG=1
-endif
-
-
-obj-$(CONFIG_LIO_TARGET)	+= iscsi_target_mod.o
Index: lio-core/drivers/target/lio-target/Makefile
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ lio-core/drivers/target/lio-target/Makefile	2010-11-15 20:34:18.928004914 +0100
@@ -0,0 +1,36 @@
+EXTRA_CFLAGS += -I$(srctree)/drivers/target/ -I$(srctree)/include/scsi/ -I$(srctree)/drivers/target/lio-target
+
+EXTRA_CFLAGS+=-D_TARGET -DPYX_ISCSI_VENDOR='"Linux-iSCSI.org"'
+
+iscsi_target_mod-y +=		iscsi_auth_chap.o \
+				iscsi_debug_opcodes.o \
+				iscsi_parameters.o \
+				iscsi_seq_and_pdu_list.o \
+				iscsi_serial.o \
+				iscsi_thread_queue.o \
+				iscsi_target_datain_values.o \
+				iscsi_target_device.o \
+				iscsi_target_discovery.o \
+				iscsi_target_erl0.o \
+				iscsi_target_erl1.o \
+				iscsi_target_erl2.o \
+				iscsi_target_login.o \
+				iscsi_target_nego.o \
+				iscsi_target_nodeattrib.o \
+				iscsi_target_tmr.o \
+				iscsi_target_tpg.o \
+				iscsi_target_util.o \
+				iscsi_target.o \
+				iscsi_target_configfs.o \
+				iscsi_target_mib.o
+
+ifdef CONFIG_LIO_TARGET_DEBUG_ERL
+iscsi_target_mod-y		+= iscsi_target_debugerl.o
+EXTRA_CFLAGS			+= -DDEBUG_ERL
+endif
+
+ifdef CONFIG_LIO_TARGET_DEBUG
+EXTRA_CFLAGS			+= -DCONFIG_ISCSI_DEBUG=1
+endif
+
+obj-$(CONFIG_LIO_TARGET)	+= iscsi_target_mod.o
