From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 12/34] cxgb4: update Kconfig and Makefile
Date: Sun, 14 Feb 2016 23:09:52 +0530
Message-ID: <3047de46b89ddbe92b6125f773e8149bde59f8a1.1455467089.git.varun@chelsio.com>
References: <5adf989f0c2d810ea5f3fedab5db9c755c1b5f1d.1455467089.git.varun@chelsio.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.32.117.8]:7321 "EHLO
	stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751529AbcBNRkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Feb 2016 12:40:11 -0500
In-Reply-To: <5adf989f0c2d810ea5f3fedab5db9c755c1b5f1d.1455467089.git.varun@chelsio.com>
In-Reply-To: <cover.1455467089.git.varun@chelsio.com>
References: <cover.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, davem@davemloft.net, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com

update Kconfig and Makefile for enabling iSCSI
DDP page pod manager.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/net/ethernet/chelsio/Kconfig        | 11 +++++++++++
 drivers/net/ethernet/chelsio/cxgb4/Makefile |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/Kconfig b/drivers/net/ethernet/chelsio/Kconfig
index 4d187f2..4686a85 100644
--- a/drivers/net/ethernet/chelsio/Kconfig
+++ b/drivers/net/ethernet/chelsio/Kconfig
@@ -96,6 +96,17 @@ config CHELSIO_T4_DCB
 
 	  If unsure, say N.
 
+config CHELSIO_T4_UWIRE
+	bool "Unified Wire Support for Chelsio T5 cards"
+	default n
+	depends on CHELSIO_T4
+	---help---
+	  Enable unified-wire offload features.
+	  Say Y here if you want to enable unified-wire over Ethernet
+	  in the driver.
+
+	  If unsure, say N.
+
 config CHELSIO_T4_FCOE
 	bool "Fibre Channel over Ethernet (FCoE) Support for Chelsio T5 cards"
 	default n
diff --git a/drivers/net/ethernet/chelsio/cxgb4/Makefile b/drivers/net/ethernet/chelsio/cxgb4/Makefile
index ace0ab9..85c9282 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/Makefile
+++ b/drivers/net/ethernet/chelsio/cxgb4/Makefile
@@ -7,4 +7,5 @@ obj-$(CONFIG_CHELSIO_T4) += cxgb4.o
 cxgb4-objs := cxgb4_main.o l2t.o t4_hw.o sge.o clip_tbl.o cxgb4_ethtool.o
 cxgb4-$(CONFIG_CHELSIO_T4_DCB) +=  cxgb4_dcb.o
 cxgb4-$(CONFIG_CHELSIO_T4_FCOE) +=  cxgb4_fcoe.o
+cxgb4-$(CONFIG_CHELSIO_T4_UWIRE) +=  cxgb4_ppm.o
 cxgb4-$(CONFIG_DEBUG_FS) += cxgb4_debugfs.o
-- 
2.0.2

