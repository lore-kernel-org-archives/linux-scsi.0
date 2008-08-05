From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] remove the unused SCSI_QLOGIC_FC_FIRMWARE option
Date: Tue, 5 Aug 2008 19:35:56 +0300
Message-ID: <20080805163556.GF22895@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762161AbYHEQhe@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Robert P. J. Day" <rpjday@crashcourse.ca>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

This option was forgotten when the SCSI_QLOGIC_FC driver was removed.

Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 25 Jun 2008

92547181b79610ddd207a9cdbea35653a1d63b8a diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 81ccbd7..a72993c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1305,14 +1305,6 @@ config SCSI_QLOGIC_FAS
 	  To compile this driver as a module, choose M here: the
 	  module will be called qlogicfas.
 
-config SCSI_QLOGIC_FC_FIRMWARE
-	bool "Include loadable firmware in driver"
-	depends on SCSI_QLOGIC_FC
-  	help
-	  Say Y to include ISP2X00 Fabric Initiator/Target Firmware, with
-	  expanded LUN addressing and FcTape (FCP-2) support, in the
-	  qlogicfc driver. This is required on some platforms.
-
 config SCSI_QLOGIC_1280
 	tristate "Qlogic QLA 1240/1x80/1x160 SCSI support"
 	depends on PCI && SCSI
