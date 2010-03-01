From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi.c: add missing kernel-doc notation for new VPD
 parameters
Date: Sun, 28 Feb 2010 17:32:45 -0800
Message-ID: <20100228173245.cb929541.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:62707 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0CABej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Feb 2010 20:34:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, James Bottomley <James.Bottomley@suse.de>

From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc notation for new function parameters:

Warning(drivers/scsi/scsi.c:1031): No description found for parameter 'buf'
Warning(drivers/scsi/scsi.c:1031): No description found for parameter 'buf_len'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>
---
 drivers/scsi/scsi.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.33-git5.orig/drivers/scsi/scsi.c
+++ linux-2.6.33-git5/drivers/scsi/scsi.c
@@ -1018,6 +1018,8 @@ static int scsi_vpd_inquiry(struct scsi_
  * scsi_get_vpd_page - Get Vital Product Data from a SCSI device
  * @sdev: The device to ask
  * @page: Which Vital Product Data to return
+ * @buf: where to store the VPD
+ * @buf_len: number of bytes in the VPD buffer area
  *
  * SCSI devices may optionally supply Vital Product Data.  Each 'page'
  * of VPD is defined in the appropriate SCSI document (eg SPC, SBC).
