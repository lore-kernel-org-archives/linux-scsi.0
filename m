From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix scsi_transport_iscsi kernel-doc notation
Date: Sat, 14 Aug 2010 13:05:41 -0700
Message-ID: <20100814130541.054a0096.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:29067 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0HNUHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 16:07:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejbscsi <james.bottomley@suse.de>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typo in scsi_transport_iscsi.c kernel-doc notation:

Warning(drivers/scsi/scsi_transport_iscsi.c:548): No description found for parameter 'cmd'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.35-git8.orig/drivers/scsi/scsi_transport_iscsi.c
+++ linux-2.6.35-git8/drivers/scsi/scsi_transport_iscsi.c
@@ -537,7 +537,7 @@ static void iscsi_scan_session(struct wo
 
 /**
  * iscsi_block_scsi_eh - block scsi eh until session state has transistioned
- * cmd: scsi cmd passed to scsi eh handler
+ * @cmd: scsi cmd passed to scsi eh handler
  *
  * If the session is down this function will wait for the recovery
  * timer to fire or for the session to be logged back in. If the
