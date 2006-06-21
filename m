From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [Ubuntu PATCH] 3w-9xyz: add proc_name
Date: Tue, 20 Jun 2006 22:32:26 -0700
Message-ID: <4498D9EA.5090909@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:18641 "EHLO
	rgminet01.oracle.com") by vger.kernel.org with ESMTP
	id S1751082AbWFUFbT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 01:31:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, jejb <James.Bottomley@SteelEye.com>, linuxraid@amcc.com

Add .proc_name member to scsi_host_template for 3w-9xxx.

http://www.kernel.org/git/?p=linux/kernel/git/bcollins/ubuntu-dapper.git;a=commitdiff;h=12fdf64086335ed596848cf17602e7a71e15ae9b


---
 drivers/scsi/3w-9xxx.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2617-pv.orig/drivers/scsi/3w-9xxx.c
+++ linux-2617-pv/drivers/scsi/3w-9xxx.c
@@ -2011,6 +2011,7 @@ static void twa_unmap_scsi_data(TW_Devic
 /* scsi_host_template initializer */
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
+	.proc_name		= "3w-9xxx",
 	.name			= "3ware 9000 Storage Controller",
 	.queuecommand		= twa_scsi_queue,
 	.eh_host_reset_handler	= twa_scsi_eh_reset,



