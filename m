From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] fix imm to build with IMM_DEBUG
Date: Sun, 1 Aug 2004 21:39:50 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040801213950.4f78903a.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:30939 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S266248AbUHBEs1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2004 00:48:27 -0400
Received: from midway.verizon.net (build.pdx.osdl.net [172.20.1.2])
	by mail.osdl.org (8.11.6/8.11.6) with SMTP id i724mQ102875
	for <linux-scsi@vger.kernel.org>; Sun, 1 Aug 2004 21:48:27 -0700
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>



Fix imm for IMM_DEBUG (changed device id struct).

Signed-off-by: Randy Dunlap <rddunlap@osdl.org>

diffstat:=
 drivers/scsi/imm.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -Naurp ./drivers/scsi/imm.c~imm_test ./drivers/scsi/imm.c
--- ./drivers/scsi/imm.c~imm_test	2004-07-29 21:50:47.000000000 -0700
+++ ./drivers/scsi/imm.c	2004-07-31 15:33:37.000000000 -0700
@@ -758,7 +762,7 @@ static void imm_interrupt(void *data)
 	case DID_OK:
 		break;
 	case DID_NO_CONNECT:
-		printk("imm: no device at SCSI ID %i\n", cmd->target);
+		printk("imm: no device at SCSI ID %i\n", cmd->device->id);
 		break;
 	case DID_BUS_BUSY:
 		printk("imm: BUS BUSY - EPP timeout detected\n");


--
