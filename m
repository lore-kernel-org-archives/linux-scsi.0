From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH 19/21] scsi: drop unused Kconfig symbol
Date: Fri, 14 Oct 2011 14:30:47 +0200
Message-ID: <1318595447.6132.78.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/scsi/Kconfig |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3878b73..8a1a23f 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -607,20 +607,6 @@ config SCSI_ARCMSR
 	  To compile this driver as a module, choose M here: the
 	  module will be called arcmsr (modprobe arcmsr).
 
-config SCSI_ARCMSR_AER
-	bool "Enable PCI Error Recovery Capability in Areca Driver(ARCMSR)"
-	depends on SCSI_ARCMSR && PCIEAER
-	default n
-	help
-	  The advanced error reporting(AER) capability is "NOT" provided by
-	  ARC1200/1201/1202 SATA RAID controllers cards.
-	  If your card is one of ARC1200/1201/1202, please use the default setting, n.
-	  If your card is other models, you could pick it
-	  on condition that the kernel version is greater than 2.6.19.
-	  This function is maintained driver by Nick Cheng. If you have any
-	  problems or suggestion, you are welcome to contact with <nick.cheng@areca.com.tw>.
-	  To enable this function, choose Y here.
-
 source "drivers/scsi/megaraid/Kconfig.megaraid"
 source "drivers/scsi/mpt2sas/Kconfig"
 
-- 
1.7.4.4
