From: Andi Kleen <ak@muc.de>
Subject: [PATCH] Mark aha152x as ISA and !64BIT driver
Date: Tue, 7 Oct 2003 19:33:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031007173323.GA1607@averell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zero.aec.at ([193.170.194.10]:19460 "EHLO zero.aec.at")
	by vger.kernel.org with ESMTP id S262497AbTJGRd0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2003 13:33:26 -0400
Received: from fred.muc.de (Percy_P_Orminder@localhost.localdomain [127.0.0.1])
	by zero.aec.at (8.11.6/8.11.2) with ESMTP id h97HXKS22484
	for <linux-scsi@vger.kernel.org>; Tue, 7 Oct 2003 19:33:20 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


aha152x seems to be not 64bit safe and spews out warnings on x86-64. 
As I think it's a ISA only driver anyways I just marked it as
ISA only and !64BIT for Alpha's sake.

diff -u linux-2.5-cleanup/drivers/scsi/Kconfig-o linux-2.5-cleanup/drivers/scsi/Kconfig
--- linux-2.5-cleanup/drivers/scsi/Kconfig-o	2003-10-02 18:12:08.000000000 +0200
+++ linux-2.5-cleanup/drivers/scsi/Kconfig	2003-12-02 16:56:28.620210248 +0100
@@ -253,7 +253,7 @@
 
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
-	depends on ISA && SCSI
+	depends on ISA && SCSI && ISA && !64BIT
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
 	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
