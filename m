From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] gdth: fix module_param() type for 'irq'
Date: Mon, 10 Jan 2005 15:44:57 -0800
Message-ID: <20050110154457.08f8f07a.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:31957 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262568AbVAJX5R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 18:57:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


linux-2610-bk13

Fix 'irq' module_param: it is an array:
drivers/scsi/gdth.c:679: warning: return from incompatible pointer type

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/gdth.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/gdth.c~gdth_modprm ./drivers/scsi/gdth.c
--- ./drivers/scsi/gdth.c~gdth_modprm	2005-01-10 10:38:39.977427800 -0800
+++ ./drivers/scsi/gdth.c	2005-01-10 15:49:49.356250816 -0800
@@ -676,7 +676,7 @@ static int force_dma32 = 0;
 
 #ifdef MODULE
 /* parameters for modprobe/insmod */
-module_param(irq, int, 0);
+module_param_array(irq, int, NULL, 0);
 module_param(disable, int, 0);
 module_param(reserve_mode, int, 0);
 module_param_array(reserve_list, int, NULL, 0);

---
