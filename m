From: Adrian Bunk <bunk@fs.tum.de>
Subject: [2.6 patch] show "Fusion MPT device support" menu only if BLK_DEV_SD
Date: Wed, 21 Jan 2004 00:25:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040120232507.GC6441@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
To: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With BLK_DEV_SD=n, I see a "Fusion MPT device support" menu I can't 
enter.

The simple patch below removes the "Fusion MPT device support" menu if 
BLK_DEV_SD=n.

Please apply
Adrian

--- linux-2.6.1-mm5/drivers/message/fusion/Kconfig.old	2004-01-21 00:19:12.000000000 +0100
+++ linux-2.6.1-mm5/drivers/message/fusion/Kconfig	2004-01-21 00:19:29.000000000 +0100
@@ -1,9 +1,9 @@
 
 menu "Fusion MPT device support"
+	depends on BLK_DEV_SD
 
 config FUSION
 	tristate "Fusion MPT (base + ScsiHost) drivers"
-	depends on BLK_DEV_SD
 	---help---
 	  LSI Logic Fusion(TM) Message Passing Technology (MPT) device support
 	  provides high performance SCSI host initiator, and LAN [1] interface
