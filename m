From: Rob Landley <rob@landley.net>
Subject: [PATCH 14/15] Update kerneldoc comments in drivers/scsi/scsi_transport_srp.c
Date: Fri, 26 Oct 2007 23:17:24 -0500
Message-ID: <200710262317.24643.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41820
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751287AbXJ0DRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:17:40 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id A6B2873938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:20:24 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/scsi_transport_srp.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/scsi_transport_srp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -r a868e8217782 drivers/scsi/scsi_transport_srp.c
--- a/drivers/scsi/scsi_transport_srp.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/scsi_transport_srp.c	Fri Oct 26 22:44:43 2007 -0500
@@ -243,7 +243,7 @@ EXPORT_SYMBOL_GPL(srp_rport_add);
 
 /**
  * srp_rport_del  --  remove a SRP remote port
- * @port:	SRP remote port to remove
+ * @rport:	SRP remote port to remove
  *
  * Removes the specified SRP remote port.
  */

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
