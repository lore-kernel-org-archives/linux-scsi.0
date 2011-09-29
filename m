From: yxlraid@gmail.com
Subject: [PATCH 8/8] [SCSI] mvsas: update driver version
Date: Thu, 29 Sep 2011 00:35:38 -0700
Message-ID: <4e834d06.6539440a.62a1.ffffff41@mx.google.com>
References: <mvsas>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39547 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1I1QgX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2011 12:36:23 -0400
In-Reply-To: <mvsas>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: jack_wang@usish.com, lucas.demarchi@profusion.mobi, maciej.trela@intel.com, dan.j.williams@intel.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiangliang Yu <yuxiangl@marvell.com>

From: Xiangliang Yu <yuxiangl@marvell.com>

-- This will synchronize the version string with internal driver.

Signed-off-by: Xiangliang Yu <yuxiangl@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index 44d7885..876c329 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -47,7 +47,7 @@
 #include "mv_defs.h"
 
 #define DRV_NAME		"mvsas"
-#define DRV_VERSION		"0.8.2"
+#define DRV_VERSION		"0.8.16"
 #define MVS_ID_NOT_MAPPED	0x7f
 #define WIDE_PORT_MAX_PHY		4
 #define mv_printk(fmt, arg ...)	\
-- 
1.7.4.4

