From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: [PATCH] buslogic init. section fix
Date: Tue, 9 Mar 2004 22:00:43 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309220043.68ad2f5c.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:41873 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S262259AbUCJGML (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 01:12:11 -0500
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


V: linux-264-rc2
D: BusLogic_AnnounceDriver() can be called after init;

diffstat:=
 drivers/scsi/BusLogic.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)


diff -Naurp ./drivers/scsi/BusLogic.c~buslog_init ./drivers/scsi/BusLogic.c
--- ./drivers/scsi/BusLogic.c~buslog_init	2004-03-06 20:57:07.000000000 -0800
+++ ./drivers/scsi/BusLogic.c	2004-03-07 15:29:40.000000000 -0800
@@ -140,7 +140,7 @@ static char *BusLogic_CommandFailureReas
   Name, Copyright Notice, and Electronic Mail Address.
 */
 
-static void __init BusLogic_AnnounceDriver(struct BusLogic_HostAdapter *HostAdapter)
+static void BusLogic_AnnounceDriver(struct BusLogic_HostAdapter *HostAdapter)
 {
   BusLogic_Announce("***** BusLogic SCSI Driver Version "
 		    BusLogic_DriverVersion " of "


--
~Randy
